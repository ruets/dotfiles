{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix

    ../home/cli/cli.nix
    ../home/desktop/desktop.nix

    ../home/modules/wallpapers/wallpapers.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
    ../home/languages/texlive.nix
  ];
}
