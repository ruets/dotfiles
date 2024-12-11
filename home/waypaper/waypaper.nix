{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    waypaper
  ];

  home.file = {
    ".config/waypaper/config.ini" = {
      enable = true;
      source = ./config.ini;
    };
  };
}
