{ config, pkgs, ... }:

{
  programs = {
    waybar = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.waybar;
    };
    rofi = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.rofi;
    };
    wlogout = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.wlogout;
    };
  };

  home.packages = with pkgs; let
    gl = config.lib.nixGL.wrap;
  in [
    (gl hyprland)
    (gl hypridle)
    (gl hyprlock)
    (gl hyprpaper)

    (gl waypaper)
    (gl nwg-dock-hyprland)
    (gl smile)

    (gl ags)
    (gl dunst)

    (gl eog)
    (gl meld)

    (gl networkmanager)
    # (gl network-manager-applet)
  ];

  home.file = {
    ".config/waybar/".source = ./waybar;

    ".config/rofi/".source = ./rofi;

    ".config/wlogout/".source = ./wlogout;

    ".config/hypr/".source = ./hypr;

    ".config/waypaper/config.ini".source = ./waypaper/config.ini;

    ".config/nwg-dock-hyprland/".source = ./nwg-dock-hyprland;

    ".config/ags/".source = ./ags;

    ".config/dunst/dunstrc".source = ./dunst/dunstrc;

    ".config/ml4w/".source = ./ml4w;
  };
}
