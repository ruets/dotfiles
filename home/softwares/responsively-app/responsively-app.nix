{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    responsively-app
  ];
}
