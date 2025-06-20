#!/bin/bash
set -e

DOTNET_TOOLS_DIR="$HOME/.dotnet/tools"
NETCOREDBG_INSTALL_TARGET="${DOTNET_TOOLS_DIR}/netcoredbg"
VERSION_FILE_PATH="${DOTNET_TOOLS_DIR}/.netcoredbg_version"

os_type=$(uname -s)
arch_type=$(uname -m)
NETCOREDBG_FILENAME=""
GITHUB_REPO_API_URL=""
NETCOREDBG_DOWNLOAD_URL_TEMPLATE=""

if [[ "$os_type" == "Linux" && "$arch_type" == "x86_64" ]]; then
  NETCOREDBG_FILENAME="netcoredbg-linux-amd64.tar.gz"
  GITHUB_REPO_API_URL="https://api.github.com/repos/Samsung/netcoredbg/releases/latest"
  NETCOREDBG_DOWNLOAD_URL_TEMPLATE="https://github.com/Samsung/netcoredbg/releases/latest/download/${NETCOREDBG_FILENAME}"
elif [[ "$os_type" == "Darwin" && "$arch_type" == "arm64" ]]; then
  NETCOREDBG_FILENAME="netcoredbg-osx-arm64.tar.gz"
  GITHUB_REPO_API_URL="https://api.github.com/repos/Cliffback/netcoredbg-macOS-arm64.nvim/releases/latest"
  NETCOREDBG_DOWNLOAD_URL_TEMPLATE="https://github.com/Cliffback/netcoredbg-macOS-arm64.nvim/releases/latest/download/${NETCOREDBG_FILENAME}"
fi

if [ -z "$GITHUB_REPO_API_URL" ]; then
  echo "Error: Unsupported platform for netcoredbg: $os_type-$arch_type."
  exit 1
fi

REMOTE_VERSION_TAG=$(curl -s "${GITHUB_REPO_API_URL}" | jq -r .tag_name)
if [ -z "$REMOTE_VERSION_TAG" ] || [ "$REMOTE_VERSION_TAG" == "null" ]; then
  REMOTE_VERSION_TAG="latest_unknown" # Fallback to ensure download attempt
fi

LOCAL_VERSION_TAG=""
[ -f "${VERSION_FILE_PATH}" ] && LOCAL_VERSION_TAG=$(cat "${VERSION_FILE_PATH}")

if [ -f "${NETCOREDBG_INSTALL_TARGET}" ] && [ "${LOCAL_VERSION_TAG}" == "${REMOTE_VERSION_TAG}" ] && [ "$REMOTE_VERSION_TAG" != "latest_unknown" ]; then
  echo "netcoredbg is up to date: ${LOCAL_VERSION_TAG}"
  exit 0
fi

ACTION="Installing"
[ -f "${NETCOREDBG_INSTALL_TARGET}" ] && ACTION="Updating"
echo "${ACTION} netcoredbg to ${REMOTE_VERSION_TAG} (current: ${LOCAL_VERSION_TAG:-not installed})."

NETCOREDBG_DOWNLOAD_URL="${NETCOREDBG_DOWNLOAD_URL_TEMPLATE}"

echo "Downloading ${NETCOREDBG_FILENAME}..."
curl -L -# -f -o "${NETCOREDBG_FILENAME}" "${NETCOREDBG_DOWNLOAD_URL}" || {
  echo -e "\nDownload failed."
  rm -f "${NETCOREDBG_FILENAME}"
  exit 1
}

TEMP_DBG_EXTRACT_DIR="dbg_extract_temp_$$"
mkdir -p "${TEMP_DBG_EXTRACT_DIR}"
echo "Extracting ${NETCOREDBG_FILENAME}..."
tar -xzf "${NETCOREDBG_FILENAME}" -C "${TEMP_DBG_EXTRACT_DIR}" || {
  echo "Extraction failed."
  rm -rf "${TEMP_DBG_EXTRACT_DIR}" "${NETCOREDBG_FILENAME}"
  exit 1
}

EXPECTED_EXECUTABLE_PATH="${TEMP_DBG_EXTRACT_DIR}/netcoredbg/netcoredbg"
if [ -f "${EXPECTED_EXECUTABLE_PATH}" ]; then
  mkdir -p "${DOTNET_TOOLS_DIR}"
  rm -f "${NETCOREDBG_INSTALL_TARGET}"
  cp "${EXPECTED_EXECUTABLE_PATH}" "${NETCOREDBG_INSTALL_TARGET}" || {
    echo "Copy failed."
    exit 1
  }
  chmod +x "${NETCOREDBG_INSTALL_TARGET}"
  echo "${REMOTE_VERSION_TAG}" >"${VERSION_FILE_PATH}"
  echo "netcoredbg ${ACTION}d successfully to version ${REMOTE_VERSION_TAG}."
else
  echo "Error: 'netcoredbg' executable not found at ${EXPECTED_EXECUTABLE_PATH}."
  echo "Contents of ${TEMP_DBG_EXTRACT_DIR}:"
  ls -lA "${TEMP_DBG_EXTRACT_DIR}"
  [ -d "${TEMP_DBG_EXTRACT_DIR}/netcoredbg" ] && {
    echo "Contents of ${TEMP_DBG_EXTRACT_DIR}/netcoredbg:"
    ls -lA "${TEMP_DBG_EXTRACT_DIR}/netcoredbg"
  }
  exit 1
fi

rm -rf "${TEMP_DBG_EXTRACT_DIR}" "${NETCOREDBG_FILENAME}"
exit 0
