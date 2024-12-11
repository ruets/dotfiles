{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nwg-dock-hyprland
  ];

  home.file = {
    ".config/nwg-dock-hyprland/" = {
      enable = true;
      source = ./nwg-dock-hyprland;
    };
  };
}
