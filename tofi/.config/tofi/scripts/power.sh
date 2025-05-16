#!/bin/bash

entries="Suspend\nReboot\nBios\nShutdown"

# get the selected entry directly from tofi and convert to lowercase
selected=$(echo -e "$entries" | tofi | tr '[:upper:]' '[:lower:]')

# Optional: Uncomment this line for debugging to see what 'selected' contains
echo "Selected: '$selected'" >>/tmp/tofi_script.log

case "$selected" in
suspend)
  systemctl suspend
  ;;
reboot)
  systemctl reboot
  ;;
bios)
  systemctl reboot --firmware-setup
  ;;
shutdown)
  systemctl poweroff
  ;;
*)
  echo "No valid option selected or action cancelled." >>/tmp/tofi_script.log
  ;;
esac
