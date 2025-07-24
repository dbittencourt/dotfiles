#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

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
sudo pacman -S --needed --noconfirm git base-devel linux-firmware amd-ucode \
  sbctl brightnessctl network-manager-applet solaar dunst hyprpolkitagent \
  bluez bluez-utils blueman \
  pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber pavucontrol gst-plugin-pipewire \
  playerctl \
  openssh libfido2 yubikey-manager gnome-keyring seahorse \
  zsh tmux neovim stow ripgrep fd fzf bat unzip tree less man wget git-delta yazi btop curlie \
  wireguard-tools fastfetch tree-sitter-cli rclone docker \
  rust dotnet-sdk go cmake clang \
  xorg-font-util xorg-fonts-misc xorg-xinit noto-fonts noto-fonts-emoji ttf-font-awesome \
  ttf-nerd-fonts-symbols ttf-jetbrains-mono-nerd \
  texlive-luatex \
  qt6-wayland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt6ct \
  hyprland hyprlock hyprpaper hypridle waybar rofi hyprpicker \
  alacritty thunar gvfs chromium transmission-gtk discord qalculate-gtk celluloid calibre \
  libreoffice-still darktable zathura-pdf-mupdf firefox \
  wine mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver libva-utils steam \
  gamemode lact radeontop lutris lib32-xcb-util-keysyms

print_status "Installing yay and extra packages..."
CURRENT_USER=$(whoami)
cd /opt/ || exit
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R "${CURRENT_USER}":"${CURRENT_USER}" yay-git
cd yay-git || exit
makepkg -si --noconfirm
yay -S --noconfirm --needed hyprshot 1password brave-bin anki-bin betterbird-bin tidal-hifi-bin \
  dmg2img protontricks protonup-qt yubico-authenticator-bin

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# install adguard
curl -fsSL https://raw.githubusercontent.com/AdguardTeam/AdGuardCLI/nightly/install.sh | sh -s – -v

print_status "Enabling services..."
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now input-remapper
# smart card daemon (yubikey)
sudo systemctl enable --now pcscd.service

print_status "Setting up dotfiles..."
cd "$HOME/dotfiles" || exit 1

configs=(
  "alacritty"
  "bat"
  "git"
  "hypr"
  "nvim"
  "themes"
  "waybar"
  "rofi"
  "solaar"
  "yazi"
  "gtk-3.0"
  "gtk-4.0"
  "qt6ct"
  "dunst"
  "MangoHud"
  "btop"
)
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

# change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  print_status "Changing default shell to zsh..."
  chsh -s "$(which zsh)" || print_error "Failed to change shell to zsh"
fi
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
