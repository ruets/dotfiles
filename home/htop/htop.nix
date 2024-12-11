{ config, pkgs, ... }:

{
  programs.htop = {
    enable = true; 
  };

  home.file = {
    ".config/htop/htoprc" = {
      enable = true;
      source = ./htoprc;
    };
  };
}
