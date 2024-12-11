{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprland
    hypridle
    hyprlock
    hyprpaper
  ];

  home.file = {
    ".config/hypr/" = {
      enable = true;
      source = ./hypr;
    };
  };
}
