{ config, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.winapps.packages.${pkgs.system}.winapps
    inputs.winapps.packages.${pkgs.system}.winapps-launcher
  ];
}