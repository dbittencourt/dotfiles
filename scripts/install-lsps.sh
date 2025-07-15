#!/bin/bash
set -e

NPM_PACKAGES=(
  vscode-langservers-extracted
  @vtsls/language-server
  @angular/language-server@16.0.0
  bash-language-server
  prettier
  sql-formatter
  @google/gemini-cli
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
if [ -f "$HOME/.nuget/plugins/netcore/CredentialProvider.Microsoft/CredentialProvider.Microsoft.dll" ]; then
  echo -e "Azure Artifacts Credential Provider is already installed."
else
  curl -sSL https://aka.ms/install-artifacts-credprovider.sh | bash
fi

dotnet tool update --all -g
if dotnet tool list -g | grep -q csharpier; then
  echo -e "csharpier is already installed."
else
  dotnet tool install --global csharpier
fi

if dotnet tool list -g | grep -q dotnet-outdated-tool; then
  echo -e "dotnet-outdated-tool is already installed."
else
  dotnet tool install --global dotnet-outdated-tool
fi

if dotnet tool list -g | grep -q dotnet-ef; then
  echo -e "dotnet-ef is already installed."
else
  dotnet tool install --global dotnet-ef
fi

bash ~/dotfiles/scripts/install-roslyn.sh
bash ~/dotfiles/scripts/install-netcoredbg.sh

echo -e "\nAll tools installed succesfully."
exit 0
