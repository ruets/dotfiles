{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    dunst
  ];

  home.file = {
    ".config/dunst/dunstrc" = {
      enable = true;
      source = ./dunstrc;
    };
  };
}
