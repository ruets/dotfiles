{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix

    ../home/cli/cli.nix

    ../home/languages/texlive.nix
  ];
}
