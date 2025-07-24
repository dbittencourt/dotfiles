#!/bin/bash

# colors for pretty output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_status() {
  echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
  echo -e "${RED}[!]${NC} $1"
}

# make sure system is updated
print_status "Updating system..."
sudo pacman -Syu --noconfirm

print_status "Installing packages..."
sudo pacman -S --needed --noconfirm git base-devel \
  openssh libfido2 yubikey-manager \
  zsh stow ripgrep fd fzf bat unzip tree less man tmux neovim wget git-delta \
  yazi btop curlie \
  texlive-luatex dotnet-sdk tree-sitter-cli go \
  xorg-font-util xorg-fonts-misc xorg-xinit ttf-font-awesome \
  ttf-nerd-fonts-symbols ttf-jetbrains-mono-nerd

print_status "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# array of configurations to stow
configs=("bat" "git" "nvim" "yazi")
for config in "${configs[@]}"; do
  print_status "Stowing $config configuration..."
  stow "$config" || {
    print_error "Failed to stow $config"
    exit 1
  }
done

# install yazi kanagawa theme
ya pack -a dangooddd/kanagawa

print_status "Building bat cache..."
bat cache --build || print_error "Failed to build bat cache"

print_status "Setting up tmux..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || {
  print_error "Failed to clone tmux plugin manager"
  exit 1
}
stow tmux || {
  print_error "Failed to stow tmux configuration"
  exit 1
}

print_status "Setting up zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
  print_error "Failed to install Oh My Zsh"
  exit 1
}
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
print_status "Installing zsh plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" 2>/dev/null || true
rm ~/.zshrc
stow zsh || {
  print_error "Failed to stow zsh configuration"
  exit 1
}

# install node and npm
nvm install 20

# install lsps, linters, daps, etc
bash ~/dotfiles/scripts/install-lsps.sh

print_success "Installation and configuration completed successfully. Please reboot the system."
