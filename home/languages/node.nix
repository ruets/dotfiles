{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
    nodePackages_latest.yarn
    nodePackages_latest.pm2
    nodePackages_latest.nodemon
  ];
}
