#!/usr/bin/env bash

# script to cycle through PipeWire audio sinks using wpctl

# Exit immediately if a command exits with a non-zero status.
set -e

status_output=$(wpctl status)
if [ -z "$status_output" ]; then
  echo "[ERROR] wpctl status returned empty output." >&2
  exit 1
fi

sinks_section=$(echo "$status_output" | sed -n '/Sinks:/,/Sources:/p' | sed '1d;$d')
sinks_cleaned=$(echo "$sinks_section" | sed 's/[├─│└]//g')
sinks_no_vol=$(echo "$sinks_cleaned" | sed 's/ *\[vol:[^]]*\] *$//')
mapfile -t sink_data < <(echo "$sinks_no_vol" | awk '
    /^\s*([*]?)\s*([0-9]+)\.\s+(.*)/ {
        id = gensub(/^\s*([*]?)\s*([0-9]+)\.\s+.*/, "\\2", "g", $0);
        is_default = (substr($0, match($0, /[^ ]/), 1) == "*");
        if (is_default) {
            print id "*";
        } else {
            print id;
        }
    }
')

if [ ${#sink_data[@]} -eq 0 ]; then
  echo "[ERROR] No audio sinks found." >&2
  exit 1
fi

if [ ${#sink_data[@]} -eq 1 ]; then
  # Exit silently if only one sink
  exit 0
fi

current_index=-1
declare -a sink_ids

for i in "${!sink_data[@]}"; do
  line="${sink_data[i]}"
  if [[ "$line" == *"*" ]]; then
    current_index=$i
    id="${line%\*}"
    sink_ids+=("$id")
  else
    sink_ids+=("$line")
  fi
done

if [ "$current_index" -eq -1 ]; then
  if [ ${#sink_ids[@]} -gt 0 ]; then
    current_index=0
    # Suppress warning in clean version, just assume first
  else
    echo "[ERROR] Could not determine default sink (no '*' found after parsing)." >&2
    exit 1
  fi
fi

num_sinks=${#sink_ids[@]}
next_index=$(((current_index + 1) % num_sinks))
next_id="${sink_ids[next_index]}"

if wpctl set-default "$next_id"; then
  : # Do nothing on success
else
  echo "[ERROR] wpctl set-default $next_id command failed." >&2
  exit 1
fi

exit 0
