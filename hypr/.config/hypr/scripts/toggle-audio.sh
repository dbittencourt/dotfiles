#!/usr/bin/env bash

# a script to cycle through PipeWire audio sinks using wpctl
set -e

# the awk script extracts the id and a "*" if the sink is the default
# the result is stored in an array where each element is "ID:*" or "ID:".
mapfile -t sinks < <(wpctl status | awk '
    /Sinks:/ {in_sinks=1; next}
    /Sources:/ {in_sinks=0}
    in_sinks && match($0, /([*]?)\s*([0-9]+)\.\s(.+)/, a) {
        print a[2] ":" a[1]
    }
')

# do nothing if there is only one sink
if [ "${#sinks[@]}" -le 1 ]; then
  exit 0
fi

current_index=-1
declare -a sink_ids

for i in "${!sinks[@]}"; do
  sink_info="${sinks[i]}"
  sink_ids+=("${sink_info%:*}") # Add the ID to our list
  if [[ "$sink_info" == *"*"* ]]; then
    current_index=$i # Found the default sink
  fi
done

if [ "$current_index" -eq -1 ]; then
  current_index=0
fi

next_index=$(((current_index + 1) % ${#sink_ids[@]}))
next_id="${sink_ids[next_index]}"

wpctl set-default "$next_id"

