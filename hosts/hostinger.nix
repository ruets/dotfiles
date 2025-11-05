{ config, pkgs, ... }:

{
  imports = [
    ../home/cli/cli.nix

    ../home/modules/vps/vps.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
    ../home/languages/go.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";
}
