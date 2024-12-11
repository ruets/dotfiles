{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home = {
    stateVersion = "24.11";
    username = "ruets";
    homeDirectory = "/home/ruets";
    language.base = "fr_FR.UTF-8";
  };
}
