#!/bin/bash
cache_file="$HOME/.cache/dotfiles/hyprland_animations_disabled"
if [[ $(cat $HOME/.config/hypr/conf/animation.conf) == *"disabled"* ]]; then
  echo ":: Toggle blocked by disabled.conf variation."
else
  if [ -f $cache_file ]; then
    hyprctl keyword animations:enabled true
    rm $cache_file
  else
    hyprctl keyword animations:enabled false
    touch $cache_file
  fi
fi

