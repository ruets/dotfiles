#!/bin/bash
#     _         _         __        ______
#    / \  _   _| |_ ___   \ \      / /  _ \
#   / _ \| | | | __/ _ \   \ \ /\ / /| |_) |
#  / ___ \ |_| | || (_) |   \ V  V / |  __/
# /_/   \_\__,_|\__\___/     \_/\_/  |_|
#

_setWallpaperRandomly() {
  dotfiles-wallpaper_engine --random
  echo ":: Next wallpaper in 60 seconds..."
  sleep 60
  _setWallpaperRandomly
}

if [ ! -f ~/.cache/dotfiles/wallpaper-automation ]; then
  touch ~/.cache/dotfiles/wallpaper-automation
  echo ":: Start wallpaper automation script"
  notify-send "Wallpaper automation process started" "Wallpaper will be changed every 60 seconds."
  _setWallpaperRandomly
else
  rm ~/.cache/dotfiles/wallpaper-automation
  notify-send "Wallpaper automation process stopped."
  echo ":: Wallpaper automation script process $wp stopped"
  wp=$(pgrep -f wallpaper-automation.sh)
  kill -KILL $wp
fi
