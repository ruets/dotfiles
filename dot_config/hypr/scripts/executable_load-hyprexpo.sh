#!/bin/bash

set -e

bind_hyprexpo() {
  hyprctl keyword unbind SUPER,Tab >/dev/null 2>&1 || true
  hyprctl keyword bind SUPER,Tab,hyprexpo:expo,toggle
}

if hyprctl plugin list 2>/dev/null | grep -q "hyprexpo"; then
  bind_hyprexpo
  exit 0
fi

for plugin in \
  /usr/lib/hyprland/plugins/libhyprexpo.so \
  /usr/lib/*/hyprland/plugins/libhyprexpo.so \
  /usr/lib/x86_64-linux-gnu/hyprland/plugins/libhyprexpo.so \
  /usr/lib/hyprland/libhyprexpo.so \
  /usr/lib/*/libhyprexpo.so; do
  if [ -f "$plugin" ]; then
    hyprctl plugin load "$plugin"
    bind_hyprexpo
    exit 0
  fi
done

plugin="$(find /usr/lib /lib -name libhyprexpo.so -print -quit 2>/dev/null || true)"
if [ -n "$plugin" ]; then
  hyprctl plugin load "$plugin"
  bind_hyprexpo
  exit 0
fi

echo "libhyprexpo.so not found; install hyprland-plugin-hyprexpo."
