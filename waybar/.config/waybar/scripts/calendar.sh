#!/bin/bash

set -euo pipefail

for cmd in thunderbird hyprctl; do
  if ! command -v "$cmd" >/dev/null; then
    printf '%s not found\n' "$cmd" >&2
    exit 127
  fi
done

thunderbird -calendar >/dev/null 2>&1 &
sleep 0.5
hyprctl dispatch 'hl.dsp.focus({ window = "title:^(Calendar - Mozilla Thunderbird)$" })'
