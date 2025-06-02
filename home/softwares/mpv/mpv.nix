{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mpv-with-scripts
  ];
}
