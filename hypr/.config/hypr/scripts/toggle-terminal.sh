#!/bin/bash
if hyprctl clients | grep -q "class: tmux-alacritty"; then
    hyprctl dispatch focuswindow "class:tmux-alacritty"
else
    alacritty --class tmux-alacritty -e tmux new -A -D -s dotfiles
fi
