#!/bin/bash

TARGET_DIR="$HOME/.cache/yay/davinci-resolve"
shopt -s nullglob
files=(DaVinci_Resolve*.zip)

if [ ${#files[@]} -gt 0 ]; then
  ORIGINAL_ZIP_FILE="${files[0]}"
  ZIP_FILE_BASENAME=$(basename "$ORIGINAL_ZIP_FILE")
  echo "Found DaVinci Resolve zip file: $ORIGINAL_ZIP_FILE"

  # move davinci resolve installer to PKGBUILD directory
  mkdir -p "$TARGET_DIR"
  MOVED_ZIP_FILE_PATH="$TARGET_DIR/$ZIP_FILE_BASENAME"
  mv "$ORIGINAL_ZIP_FILE" "$MOVED_ZIP_FILE_PATH"

  # davinci requires rocm when you use an amd video card
  # rocm insnt included in mesa, you have to install it with:
  sudo pacman -S --needed --noconfirm rocm-opencl-runtime

  echo "Installing Davinci Resolve with yay..."
  yay -S davinci-resolve

  echo "Deleting the zip file from cache: $MOVED_ZIP_FILE_PATH..."
  if [ -f "$MOVED_ZIP_FILE_PATH" ]; then
    rm "$MOVED_ZIP_FILE_PATH"
  fi

  echo "Davinci Resolve installed successfully"
else
  # no file found
  echo "Error: Couldn't find Davinci Resolve installer." >&2
  exit 1
fi

exit 0
