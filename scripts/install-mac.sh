#!/bin/bash

# Colors for pretty output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored status messages
print_status() {
  echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
  echo -e "${RED}[!]${NC} $1"
}

print_status "Installing developer tools..."
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
softwareupdate -i "$PROD" --verbose
rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
print_success "Developer tools installed"

print_status "Installing Rosetta 2..."
softwareupdate --install-rosetta --agree-to-license
print_success "Rosetta 2 installed"

print_status "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
print_success "Brew installed"

print_status "Installing cli tools..."
brew install tree wget curlie stow bat git git-delta tmux neovim gpg openssh \
  libfido2 ykman pinentry-mac nvm glow zsh fzf fd rg mas wireguard-go yazi \
  dotnet btop
print_success "cli tools installed"

print_status "Installing gui apps..."
brew install --cask 1password adguard affinity-designer affinity-photo \
  affinity-publisher airflow alacritty anki bettermouse calibre darktable \
  discord freedom fujifilm-x-raw-studio libreoffice lulu obs pearcleaner \
  phoenix-slides raycast the-unarchiver tidal transmission vlc \
  yubico-authenticator yubico-yubikey-manager whatsapp
brew cleanup
print_status "gui apps installed"

print_status "Installing Apple Store apps..."
mas install 1569813296 # 1Password for Safari
mas install 424390742  # Compressor
mas install 424389933  # Final Cut Pro
mas install 1274495053 # Microsoft To Do
print_success "Apple Store apps installed"

print_status "Settint up dotfiles..."
cd "$HOME/dotfiles" || {
  print_error "Failed to change directory to $HOME/dotfiles"
  exit 1
}

# Array of configurations to stow
configs=("alacritty" "bat" "git" "nvim" "yazi" "btop")
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
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" 2>/dev/null || true
rm ~/.zshrc
stow zsh || {
  print_error "Failed to stow zsh configuration"
  exit 1
}

# install node and npm
nvm install 18.20

# install lps, linters, daps, etc
bash ~/dotfiles/scripts/install-lsps.sh

print_status "Setting up macOS preferences..."
# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
defaults write com.apple.dock tilesize -int 16
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -float 80
defaults write com.apple.dock autohide -bool true
defaults write com.apple.spotlight SiriSuggestionsEnabled -bool false
defaults write -globalDomain AppleInterfaceStyle Dark
# Set the key repeat rate (lower values result in a faster rate)
defaults write NSGlobalDomain KeyRepeat -int 1
# Set the initial key repeat delay (lower value means a shorter delay before repeating)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# This command configures macOS to use function keys as standard F1, F2, etc
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

killall cfprefsd
killall ControlCenter
killall Dock
killall Finder
killall SystemUIServer
# todo: cleanup
rm ~/.zprofile

print_success "Installation and configuration completed successfully. Please reboot the system."
