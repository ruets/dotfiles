{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true; 
  };

  home.file = {
    ".config/rofit/" = {
      enable = true;
      source = ./rofi;
    };
  };
}
