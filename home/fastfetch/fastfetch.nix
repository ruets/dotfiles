{ config, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
  };

  home.file = {
    ".config/fastfetch/config.jsonc" = {
      enable = true;
      source = ./config.jsonc;
    };
  };
}
