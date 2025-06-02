{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    galaxy-buds-client
  ];
}
