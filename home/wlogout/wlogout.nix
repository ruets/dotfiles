{ config, pkgs, ... }:

{
  programs.wlogout = {
    enable = true; 
  };

  home.file = {
    ".config/wlogout/" = {
      enable = true;
      source = ./wlogout;
    };
  };
}
