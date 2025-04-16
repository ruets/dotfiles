{ config, pkgs, ... }:

{
  # programs = {
  #   texlive.enable = true; 
  # };

  home.packages = with pkgs; [
    texlive.combined.scheme-full
  ];
}
