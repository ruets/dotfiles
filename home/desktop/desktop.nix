{ config, pkgs, ... }:

{
  programs = {
    waybar.enable = true;
    rofi.enable = true;
    wlogout.enable = true;
  };

  home.packages = with pkgs; [
    hyprland
    hypridle
    hyprlock
    hyprpaper

    waypaper
    nwg-dock-hyprland
    smile

    ags
    dunst

    eog

    networkmanager
    network-manager-applet
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
