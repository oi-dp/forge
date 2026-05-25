#!/usr/bin/env bash

STATE_FILE="/tmp/waybar_updates_state"
count=$(checkupdates 2>/dev/null | wc -l)

if [ -f "$STATE_FILE" ]; then
  prev_state=$(cat "$STATE_FILE")
else
  prev_state=0
fi

if [ "$count" -gt 0 ]; then
  current_state=1
else
  current_state=0
fi

if [ "$prev_state" -eq 0 ] && [ "$current_state" -eq 1 ]; then
  notify-send -u normal "System Updates" "$count package update(s) available"
fi

echo "$current_state" >"$STATE_FILE"

if [ "$count" -gt 0 ]; then
  echo "{\"text\": \" $count\", \"class\": \"updates\", \"tooltip\": \"$count updates available\"}"
else
  echo "{\"text\": \" \", \"class\": \"noupdates\", \"tooltip\": \"System up to date\"}"
fi
