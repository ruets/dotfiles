{ config, pkgs, ... }:

{
  programs.cava = {
    enable = true;
  };

  home.file = {
    ".config/cava/" = {
      enable = true;
      source = ./cava;
    };
  };
}
