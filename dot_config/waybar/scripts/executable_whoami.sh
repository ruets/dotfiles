#!/usr/bin/env bash

STATE=/tmp/waybar-whoami

case "$1" in
--toggle)
  if [[ -f "$STATE" ]]; then
    rm "$STATE"
  else
    touch "$STATE"
  fi
  pkill -RTMIN+8 waybar
  exit 0
  ;;
esac

if [[ -f "$STATE" ]]; then
  TEXT="IP : $(ip route get 1.1.1.1 | awk '{print $7; exit}')"
else
  TEXT="$USER@$(hostnamectl --static)"
fi

UPTIME="$(uptime -p)"

printf '{"text":"%s","tooltip":"%s"}\n' "$TEXT" "$UPTIME"
