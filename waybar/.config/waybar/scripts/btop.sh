#!/bin/bash

set -euo pipefail

case "${1:-}" in
cpu)
  sort="cpu direct"
  ;;
memory)
  sort="memory"
  ;;
*)
  printf 'usage: %s cpu|memory\n' "${0##*/}" >&2
  exit 2
  ;;
esac

for cmd in ghostty btop; do
  if ! command -v "$cmd" >/dev/null; then
    printf '%s not found\n' "$cmd" >&2
    exit 127
  fi
done

uid="${UID:-$(id -u)}"
run_dir="${XDG_RUNTIME_DIR:-/tmp}/waybar-btop-$uid"
src_conf="${XDG_CONFIG_HOME:-$HOME/.config}/btop/btop.conf"
conf="$run_dir/$1.conf"

mkdir -p "$run_dir"
chmod 700 "$run_dir"

if [[ -r "$src_conf" ]]; then
  cp "$src_conf" "$conf"
else
  btop --default-config > "$conf"
fi

has_sort=false
while IFS= read -r line; do
  if [[ "$line" == proc_sorting\ =* ]]; then
    has_sort=true
    break
  fi
done < "$conf"

if "$has_sort"; then
  sed -i "s/^proc_sorting = .*/proc_sorting = \"$sort\"/" "$conf"
else
  printf '\nproc_sorting = "%s"\n' "$sort" >> "$conf"
fi

ghostty --class=btop.ghostty -e btop --config "$conf"
