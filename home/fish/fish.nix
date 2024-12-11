{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
  };

  home.file = {
    ".config/fish/" = {
      enable = true;
      source = ./fish;
    };
  };
}
