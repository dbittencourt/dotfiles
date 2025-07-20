#!/bin/bash

# terminal (workspace 6)
if hyprctl clients | grep -E -q "class: terminal-obs([,;]|$)"; then
  hyprctl dispatch movetoworkspace 6,class:^terminal-obs$
  hyprctl dispatch fullscreen class:^terminal-obs$
else
  hyprctl dispatch exec '[workspace 6 silent; fullscreen] alacritty -o font.size=18 --class terminal-obs'
  sleep 1
fi

# keystokes (workspace 7)
if hyprctl clients | grep -E -q "class: showmethekey-gtk([,;]|$)"; then
  hyprctl dispatch movetoworkspace 7,class:^showmethekey-gtk$
  hyprctl dispatch movetoworkspace 7,class:^one.alynx.showmethekey$
else
  hyprctl dispatch exec '[workspace 7 silent] showmethekey-gtk'
  hyprctl dispatch setfloating class:^one.alynx.showmethekey$
fi

# obs (workspace 5)
if hyprctl clients | grep -E -q "class: com.obsproject.Studio([,;]|$)"; then
  hyprctl dispatch movetoworkspace 5,class:^com.obsproject.Studio$
else
  hyprctl dispatch exec '[workspace 5 silent] obs'
fi

sleep 1
hyprctl dispatch movetoworkspace 5,class:^hyprland-share-picker$
hyprctl dispatch focuswindow class:^com.obsproject.Studio$

