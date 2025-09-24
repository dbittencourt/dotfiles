#!/bin/bash

entries="Lock\nSuspend\nReboot\nBios\nShutdown"

# get the selected entry directly from rofi and convert to lowercase
selected=$(echo -e "$entries" |
  rofi -dmenu -theme-str 'window {width: 10em; height: 10em;}' |
  tr '[:upper:]' '[:lower:]')

case "$selected" in
lock)
  hyprlock
  ;;
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
  echo "No valid option selected or action cancelled."
  ;;
esac
