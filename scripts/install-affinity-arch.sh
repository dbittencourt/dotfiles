#!/bin/bash

echo "Checking dependencies..."
sudo pacman -S --needed --noconfirm jq curl tar lutris

REPO_OWNER="Twig6943"
REPO_NAME="ElementalWarrior-Wine-binaries"
ASSET_NAME="ElementalWarriorWine-x86_64.tar.gz"
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest"

echo "Downloading custom wine release of $REPO_OWNER/$REPO_NAME..."
release_data=$(curl -sL "$API_URL")
if [ -z "$release_data" ]; then
  echo "Error: Failed to fetch release data from GitHub API." >&2
  exit 1
fi

if echo "$release_data" | jq -e '.message' >/dev/null; then
  error_message=$(echo "$release_data" | jq -r '.message')
  echo "Error from GitHub API: $error_message" >&2
  exit 1
fi

download_url=$(echo "$release_data" | jq -r --arg ASSET_NAME "$ASSET_NAME" '.assets[] | select(.name==$ASSET_NAME) | .browser_download_url')
if [ -z "$download_url" ] || [ "$download_url" == "null" ]; then
  echo "Error: Couldn't find custom wine file." >&2
  exit 1
fi

curl -L -O "$download_url"
DOWNLOAD_EXIT_CODE=$?

if [ $DOWNLOAD_EXIT_CODE -eq 0 ]; then
  echo "Preparing to install $ASSET_NAME for Lutris..."
  mkdir -p "$LUTRIS_WINE_DIR"
  tar -xzf "$ASSET_NAME"
  EXTRACTED_DIR_NAME="${ASSET_NAME%.tar.gz}"
  mv "$EXTRACTED_DIR_NAME" "$LUTRIS_WINE_DIR/"
  MOVE_EXIT_CODE=$?
  if [ $MOVE_EXIT_CODE -ne 0 ]; then
    echo "Error: Failed to move '$EXTRACTED_DIR_NAME' to '$LUTRIS_WINE_DIR/'." >&2
    echo "Please check permissions and paths." >&2
    rm "$ASSET_NAME"
    exit 1
  fi
  rm "$ASSET_NAME"
else
  echo "Error: Download failed for $ASSET_NAME." >&2
  exit 1
fi

echo "Lutris and custom wine configured successfully. Finish install with:"
echo "https://github.com/Twig6943/AffinityOnLinux/blob/main/Guides/Lutris/Guide.md"

exit 0
