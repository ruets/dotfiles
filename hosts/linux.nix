{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix

    ../home/cli/cli.nix
    ../home/desktop/desktop.nix

    ../home/languages/texlive.nix
  ];
}
