{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true; 
  };

  home.file = {
    ".config/waybar/" = {
      enable = true;
      source = ./waybar;
    };
  };
}
