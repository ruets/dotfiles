{ config, pkgs, ... }:

let
  npm_packages = pkgs.callPackage ./npm_packages {};
in
{
  home.packages = with pkgs; [
    npm_packages
    prefetch-npm-deps

    nodejs
    nodePackages_latest.yarn
    nodePackages_latest.pm2
    nodePackages_latest.nodemon
  ];
}
