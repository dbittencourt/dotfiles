print_status "Installing surface linux kernel..."
curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc |
  sudo pacman-key --add -
sudo pacman-key --lsign-key 56C464BAAC421453
print_status "Adding Surface Linux repository..."
echo -e "\n[linux-surface]\nServer = https://pkg.surfacelinux.com/arch/" | sudo tee -a /etc/pacman.conf >/dev/null || {
  print_error "Failed to append repository configuration"
  exit 1
}
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm linux-surface linux-surface-headers iptsd
