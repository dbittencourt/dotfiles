#!/bin/bash
set -e

ORG="azure-public"
PROJECT="vside"
FEED="vs-impl"
PKG_ID_BASE="Microsoft.CodeAnalysis.LanguageServer"
API_VER="7.1-preview.1"

SERVER_FILES_INSTALL_DIR="$HOME/.dotnet/tools/roslyn"
DOTNET_TOOLS_DIR="$HOME/.dotnet/tools"
DLL_FILENAME="Microsoft.CodeAnalysis.LanguageServer.dll"
COMMAND_NAME="Microsoft.CodeAnalysis.LanguageServer"
COMMAND_SCRIPT_PATH="${DOTNET_TOOLS_DIR}/${COMMAND_NAME}"
VERSION_FILE="${SERVER_FILES_INSTALL_DIR}/.version"

os_type=$(uname -s)
arch_type=$(uname -m)
platform_suffix=""
if [[ "$os_type" == "Linux" && "$arch_type" == "x86_64" ]]; then
  platform_suffix="linux-x64"
elif [[ "$os_type" == "Darwin" && "$arch_type" == "arm64" ]]; then
  platform_suffix="osx-arm64"
  [ -z "$platform_suffix" ] && {
    echo "Error: Could not determine platform."
    exit 1
  }
fi

PKG_ID="${PKG_ID_BASE}.${platform_suffix}"
PROJECT_API_PATH="" && [ -n "$PROJECT" ] && PROJECT_API_PATH="/$PROJECT"
PROJECT_PKG_PATH="" && [ -n "$PROJECT" ] && PROJECT_PKG_PATH="/$(echo "$PROJECT" | tr '[:upper:]' '[:lower:]')"
PKG_ID_LOWER=$(echo "$PKG_ID" | tr '[:upper:]' '[:lower:]')

VERSIONS_URL="https://feeds.dev.azure.com/${ORG}${PROJECT_API_PATH}/_apis/packaging/Feeds/${FEED}/Packages?packageNameQuery=${PKG_ID}&api-version=${API_VER}"
ALL_VERSIONS_LIST=$(curl -s -H "Accept: application/json" "${VERSIONS_URL}" | jq -r --arg pkgid "$PKG_ID_LOWER" '.value[] | select(.name | ascii_downcase == $pkgid) | .versions[] | select(.isListed == true or .isListed == null or .isListed == "") | .version')
[ -z "$ALL_VERSIONS_LIST" ] && {
  echo "No versions found for ${PKG_ID}."
  exit 1
}

LATEST_STABLE_VERSION=$(echo "$ALL_VERSIONS_LIST" | grep -Ev -- '-(alpha|beta|rc|preview|dev|[0-9]+-[0-9]+)' | sort -V | tail -n 1)
[ -z "$LATEST_STABLE_VERSION" ] && {
  echo "No stable version found for ${PKG_ID}."
  exit 1
}

CURRENTLY_INSTALLED_VERSION="" && [ -f "${VERSION_FILE}" ] && CURRENTLY_INSTALLED_VERSION=$(cat "${VERSION_FILE}")

# Path to the actual DLL that the command script will execute
PATH_TO_ACTUAL_DLL="${SERVER_FILES_INSTALL_DIR}/${DLL_FILENAME}"

if [ "$LATEST_STABLE_VERSION" == "$CURRENTLY_INSTALLED_VERSION" ]; then
  echo "Roslyn LSP (${COMMAND_NAME}) is up to date: ${CURRENTLY_INSTALLED_VERSION}"
  if [ -f "${COMMAND_SCRIPT_PATH}" ] && [ -f "${PATH_TO_ACTUAL_DLL}" ]; then
    exit 0
  else
    echo "Command script or target DLL missing, ensuring..."
    if [ ! -f "${PATH_TO_ACTUAL_DLL}" ]; then
      echo "Target DLL ${PATH_TO_ACTUAL_DLL} missing, proceeding to full install/update."
    else
      mkdir -p "${DOTNET_TOOLS_DIR}"
      ABSOLUTE_PATH_TO_ACTUAL_DLL=$(cd "$(dirname "${PATH_TO_ACTUAL_DLL}")" && pwd)/$(basename "${PATH_TO_ACTUAL_DLL}")
      echo -e "#!/bin/sh\nexec dotnet \"${ABSOLUTE_PATH_TO_ACTUAL_DLL}\" \"\$@\"" >"${COMMAND_SCRIPT_PATH}"
      chmod +x "${COMMAND_SCRIPT_PATH}"
      echo "Command script ${COMMAND_NAME} ensured."
      exit 0
    fi
  fi
fi

if [ -n "$CURRENTLY_INSTALLED_VERSION" ] && [ "$LATEST_STABLE_VERSION" != "$CURRENTLY_INSTALLED_VERSION" ]; then
  if [ "$(printf "%s\n%s" "$CURRENTLY_INSTALLED_VERSION" "$LATEST_STABLE_VERSION" | sort -V | tail -n 1)" != "$LATEST_STABLE_VERSION" ]; then
    echo "Current ($CURRENTLY_INSTALLED_VERSION) not older than latest ($LATEST_STABLE_VERSION). No update."
    exit 0
  fi
  echo "Updating Roslyn LSP (${COMMAND_NAME}) from ${CURRENTLY_INSTALLED_VERSION} to ${LATEST_STABLE_VERSION}..."
elif [ -z "$CURRENTLY_INSTALLED_VERSION" ]; then
  echo "Installing Roslyn LSP (${COMMAND_NAME}) version ${LATEST_STABLE_VERSION}..."
fi

FILENAME="${PKG_ID}.${LATEST_STABLE_VERSION}.nupkg"
DOWNLOAD_URL="https://pkgs.dev.azure.com/$(echo "$ORG" | tr '[:upper:]' '[:lower:]')${PROJECT_PKG_PATH}/_packaging/$(echo "$FEED" | tr '[:upper:]' '[:lower:]')/nuget/v3/flat2/${PKG_ID_LOWER}/$(echo "$LATEST_STABLE_VERSION" | tr '[:upper:]' '[:lower:]')/${PKG_ID_LOWER}.$(echo "$LATEST_STABLE_VERSION" | tr '[:upper:]' '[:lower:]').nupkg"

echo "Downloading ${FILENAME}..."
curl -L -# -f -o "${FILENAME}" "${DOWNLOAD_URL}" || {
  echo -e "\nDownload failed."
  rm -f "${FILENAME}"
  exit 1
}

TEMP_UNZIP_DIR="nuget_extract_temp_$$"
mkdir -p "${TEMP_UNZIP_DIR}"
unzip -q "${FILENAME}" -d "${TEMP_UNZIP_DIR}" || {
  echo "Unzip failed."
  rm -rf "${TEMP_UNZIP_DIR}" "${FILENAME}"
  exit 1
}

SOURCE_CONTENT_PATH="${TEMP_UNZIP_DIR}/content/LanguageServer/${platform_suffix}"

if [ -d "${SOURCE_CONTENT_PATH}" ]; then
  echo "Installing server files to ${SERVER_FILES_INSTALL_DIR}..."
  mkdir -p "${SERVER_FILES_INSTALL_DIR}" && rm -rf "${SERVER_FILES_INSTALL_DIR:?}/"*
  cp -a "${SOURCE_CONTENT_PATH}/." "${SERVER_FILES_INSTALL_DIR}/" || {
    echo "Copy failed."
    exit 1
  }

  echo "Creating command script ${COMMAND_NAME} at ${COMMAND_SCRIPT_PATH}..."
  mkdir -p "${DOTNET_TOOLS_DIR}"
  ABSOLUTE_PATH_TO_ACTUAL_DLL=$(cd "$(dirname "${PATH_TO_ACTUAL_DLL}")" && pwd)/$(basename "${PATH_TO_ACTUAL_DLL}")
  echo -e "#!/bin/sh\nexec dotnet \"${ABSOLUTE_PATH_TO_ACTUAL_DLL}\" \"\$@\"" >"${COMMAND_SCRIPT_PATH}"
  chmod +x "${COMMAND_SCRIPT_PATH}"

  echo "${LATEST_STABLE_VERSION}" >"${VERSION_FILE}"
  echo "Roslyn LSP v${LATEST_STABLE_VERSION} installed. Server files in ${SERVER_FILES_INSTALL_DIR}."
  echo "Command is: ${COMMAND_NAME}"
else
  echo "Error: Source content path '${SOURCE_CONTENT_PATH}' not found."
  exit 1
fi

rm -rf "${TEMP_UNZIP_DIR}" "${FILENAME}"
exit 0
