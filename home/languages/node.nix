{ config, pkgs, ... }:

let
  npm_packages = pkgs.callPackage ./npm_packages {};
in
{
  home.packages = with pkgs; [
    nodejs
    pnpm
    pm2
  ];
}
