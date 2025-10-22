#!/bin/bash
if hyprctl clients | grep -q "class: com.mitchellh.ghostty"; then
  hyprctl dispatch focuswindow "class:com.mitchellh.ghostty"
else
  # leave it commented just in case I ever return to alacritty + tmux
  # alacritty --class terminal-personal -e tmux new -A -D -s dotfiles
  ghostty
fi
