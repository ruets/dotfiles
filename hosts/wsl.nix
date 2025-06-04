{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix

    ../home/cli/cli.nix

    ../home/languages/java.nix
    ../home/languages/node.nix
    ../home/languages/python.nix
    ../home/languages/texlive.nix
    ../home/languages/go.nix
  ];
}
