#!/bin/bash
set -e

NPM_PACKAGES=(
  vscode-langservers-extracted
  @vtsls/language-server
  @angular/language-server@16.0.0
  bash-language-server
  prettier
)
echo "Installing some packages globally with npm..."
echo "Packages: ${NPM_PACKAGES[*]}"
npm install -g "${NPM_PACKAGES[@]}"

PACKAGES=(shfmt shellcheck lua-language-server stylua marksman ruff)
echo -e "\nInstalling some packages with OS-specific package managers..."
echo "Packages: ${PACKAGES[*]}"
os_type=$(uname -s)
if [[ "$os_type" == "Linux" ]]; then
  echo "Detected Linux. Using yay to install packages..."
  yay -S --noconfirm --needed "${PACKAGES[@]}"
elif [[ "$os_type" == "Darwin" ]]; then
  echo "Detected macOS. Using brew to install packages..."
  brew install "${PACKAGES[@]}"
  # clang-format doesn't ship with clang in homebrew package
  brew install clang-format
else
  echo "Warning: Unsupported OS '$os_type'. Skipping OS-specific packages."
fi

echo -e "\nInstalling dotnet lsp/dap/tools..."
curl -sSL https://aka.ms/install-artifacts-credprovider.sh | bash
dotnet tool install --global csharpier
bash ~/dotfiles/scripts/install-roslyn.sh
bash ~/dotfiles/scripts/install-netcoredbg.sh

echo -e "\nAll tools installed succesfully"
exit 0
