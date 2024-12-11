{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix
    ../home/git/git.nix
  ];
}
