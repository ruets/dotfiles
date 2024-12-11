{ config, pkgs, ... }:

{
  programs.pywal = {
    enable = true; 
  };

  home.file = {
    ".config/wal/" = {
      enable = true;
      source = ./wal;
    };
  };
}
