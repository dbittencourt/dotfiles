#!/bin/bash

output=$(asdbctl get 2>/dev/null)

if [ $? -eq 0 ]; then
  # extract the % from the output (e.g., "brightness 60")
  value=$(echo "$output" | cut -d' ' -f2)

  # read the cached value (if it exists)
  cached_value=$(cat /tmp/waybar_brightness 2>/dev/null)

  # If the current value is different from the cached one, update the cache
  # Check if value is not empty before comparing/writing
  if [ -n "$value" ] && [ "$cached_value" != "$value" ]; then
    echo "$value" >/tmp/waybar_brightness
  fi
  echo {\"percentage\": "$value"}
else
  echo {\"percentage\": $(cat /tmp/waybar_brightness 2>/dev/null || echo 0)}
fi
