#!/bin/bash
set -e

echo "Installing global npm packages"
npm install -g \
  vscode-langservers-extracted \
  some-sass-language-server \
  @vtsls/language-server \
  @angular/language-server@15.2.10 \
  bash-language-server \
  prettier

echo "Installing OS-specific packages"
PACKAGES_TO_INSTALL="shfmt shellcheck lua-language-server stylua marksman ruff"

os_type=$(uname -s)
if [[ "$os_type" == "Linux" ]]; then
  echo "Detected Linux. Using yay to install packages..."
  for pkg in ${PACKAGES_TO_INSTALL}; do
    echo "Installing ${pkg} with yay..."
    yay -S --noconfirm "${pkg}"
  done
elif [[ "$os_type" == "Darwin" ]]; then
  echo "Detected macOS. Using brew to install packages..."
  for pkg in ${PACKAGES_TO_INSTALL}; do
    echo "Installing ${pkg} with brew..."
    brew install "${pkg}"
  done
else
  echo "Warning: Unsupported OS '$os_type'. Skipping OS-specific packages."
fi

echo "Installing dotnet tools"
dotnet tool install --global csharpier
bash ./install-roslyn.sh
bash ./install-netcoredbg.sh

echo "All tools installed succesfully"
exit 0
