{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zathura-with-plugins
  ];
}
