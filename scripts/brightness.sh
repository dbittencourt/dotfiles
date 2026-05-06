#!/usr/bin/env bash
set -euo pipefail

step=5
max=100
signal=4
stale_after=30
sync_settle=0.15
sync_attempts=2
display=1

user=$(id -u)
state_dir="/tmp/brightness-$user"
if [[ -L "$state_dir" ]]; then
  printf 'brightness state dir must not be a symlink\n' >&2
  exit 1
fi

mkdir -p "$state_dir"
chmod 700 "$state_dir"

state_owner=$(stat -c %u "$state_dir")
state_mode=$(stat -c %a "$state_dir")

if [[ "$state_owner" != "$user" ]] || ((8#$state_mode & 0077)); then
  printf 'brightness state dir must be private and owned by current user\n' >&2
  exit 1
fi

state_lock="$state_dir/state.lock"
sync_lock="$state_dir/sync.lock"
cache="$state_dir/value"
sync_request="$state_dir/sync.request"

ddc() {
  timeout 4s ddcutil --display "$display" "$@"
}

refresh_waybar() {
  local pid
  local uid

  for pid in $(pidof waybar 2>/dev/null || true); do
    uid=$(stat -c %u "/proc/$pid" 2>/dev/null || true)
    [[ "$uid" == "$user" ]] || continue
    kill -s "RTMIN+$signal" "$pid" 2>/dev/null || true
  done
}

clamp() {
  local value=$1

  if ((value < 0)); then
    printf '0\n'
  elif ((value > max)); then
    printf '%s\n' "$max"
  else
    printf '%s\n' "$value"
  fi
}

read_cached() {
  if [[ -r "$cache" ]]; then
    read -r value <"$cache"
    if [[ "$value" =~ ^[0-9]+$ ]]; then
      printf '%s\n' "$(clamp "$value")"
      return
    fi
  fi

  printf '0\n'
}

read_monitor() {
  {
    flock -n 8 || return 0
    output=$(ddc getvcp 10 2>/dev/null || true)
  } 8>"$sync_lock"

  value=$(
    printf '%s\n' "$output" |
      awk -F 'current value = *|,' '/current value/ { print $2; exit }'
  )

  [[ -n "${value:-}" ]] && write_cached "$value"
}

cache_is_stale() {
  local modified
  local now

  [[ ! -r "$cache" ]] && return 0

  modified=$(stat -c %Y "$cache" 2>/dev/null || printf '0\n')
  now=$(date +%s)

  ((now - modified > stale_after))
}

write_cached() {
  printf '%s\n' "$(clamp "$1")" >"$cache"
}

set_cached() {
  local value=$1

  if [[ ! "$value" =~ ^[0-9]+$ ]]; then
    printf 'brightness must be a number from 0 to %s\n' "$max" >&2
    exit 2
  fi

  {
    flock 9
    write_cached "$value"
  } 9>"$state_lock"
}

adjust_cached() {
  local delta=$1
  local value=0

  {
    flock 9
    if [[ -r "$cache" ]]; then
      read -r value <"$cache"
    fi

    if [[ ! "$value" =~ ^[0-9]+$ ]]; then
      value=0
    fi

    value=$((value + delta))

    if ((value < 0)); then
      value=0
    elif ((value > max)); then
      value=$max
    fi

    printf "%s\n" "$value" >"$cache"
  } 9>"$state_lock"
}

sync_brightness() {
  local attempt
  local latest
  local resync=0
  local target

  {
    flock -n 9 || return 0
    for ((attempt = 0; attempt < sync_attempts; attempt++)); do
      rm -f "$sync_request"
      sleep "$sync_settle"
      read -r target <"$cache"
      ddc --noverify setvcp 10 "$target" >/dev/null || true

      read -r latest <"$cache"
      [[ "$target" == "$latest" && ! -e "$sync_request" ]] && break
    done

    [[ -e "$sync_request" ]] && resync=1
  } 9>"$sync_lock"

  ((resync)) && start_sync
}

start_sync() {
  : >"$sync_request"
  "$0" sync >/dev/null 2>&1 &
}

start_refresh() {
  "$0" refresh >/dev/null 2>&1 &
}

case "${1:-get}" in
  get)
    if cache_is_stale; then
      start_refresh
    fi

    printf '%s%%\n' "$(read_cached)"
    ;;
  up)
    adjust_cached "$step"
    refresh_waybar
    start_sync
    ;;
  down)
    adjust_cached "-$step"
    refresh_waybar
    start_sync
    ;;
  set)
    set_cached "${2:-}"
    refresh_waybar
    start_sync
    ;;
  init)
    read_monitor
    printf '%s%%\n' "$(read_cached)"
    ;;
  refresh)
    read_monitor
    refresh_waybar
    ;;
  sync)
    sync_brightness
    ;;
  *)
    printf 'usage: brightness.sh get|up|down|set VALUE|init|refresh|sync\n' >&2
    exit 2
    ;;
esac
