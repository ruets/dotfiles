{ config, pkgs, ... }:

{
  imports = [
    ../home/cli/cli.nix

    ../home/modules/vps.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
  ];

  home = {
    username = "root";
    homeDirectory = "/root";
  };
}
