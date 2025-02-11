{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    video2midi
  ];
 }
