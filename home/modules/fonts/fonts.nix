{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    fira
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];
}
