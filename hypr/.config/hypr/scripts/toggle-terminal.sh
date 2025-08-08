#!/bin/bash
if hyprctl clients | grep -q "class: terminal-personal"; then
  hyprctl dispatch focuswindow "class:terminal-personal"
else
  alacritty --class terminal-personal -e tmux new -A -D -s dotfiles
fi
