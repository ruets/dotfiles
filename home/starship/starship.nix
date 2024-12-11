{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true; 
  };

  home.file = {
    ".config/starship/starship.toml" = {
      enable = true;
      source = ./starship.toml;
    };
  };
}
