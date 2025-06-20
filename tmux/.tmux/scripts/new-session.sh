#!/usr/bin/env bash
set -eo pipefail

SEARCH_ROOT="$HOME"

sessions=$(tmux list-sessions -F '#S' 2>/dev/null || true)
[ -z "$sessions" ] && sessions="(no sessions found)"

set +e
fzf_result=$(echo "$sessions" | fzf --prompt="Type or select session name: " \
  --print-query --height=10 --layout=reverse)
set -e

query=$(echo "$fzf_result" | sed -n 1p)
selection=$(echo "$fzf_result" | sed -n 2p)

if [ -n "$selection" ]; then
  session="$selection"
else
  session="$query"
fi

[ -z "${session:-}" ] && exit 0

session_exists() { tmux has-session -t "$1" 2>/dev/null; }
if session_exists "$session"; then
  tmux switch-client -t "$session" 2>/dev/null
  exit 0
fi

dirs=$(find "$SEARCH_ROOT" \
  \( -name node_modules -o -name .git -o -name dist \) -prune -o -type d -maxdepth 5 -print 2>/dev/null)

set +e
dir=$(echo "$dirs" | fzf --prompt="Select directory: ")
set -e

[ -z "${dir:-}" ] && exit 0
[ ! -d "$dir" ] && exit 1

tmux new-session -d -s "$session" -c "$dir" -n code 2>/dev/null
tmux new-window -t "$session:" -n server -c "$dir" 2>/dev/null
tmux new-window -t "$session:" -n whatever -c "$dir" 2>/dev/null
tmux select-window -t "$session:1" 2>/dev/null
tmux switch-client -t "$session" 2>/dev/null
exit 0
