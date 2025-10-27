{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix

    ../home/cli/cli.nix

    ../home/modules/wallpapers/wallpapers.nix

    ../home/softwares/kitty/kitty.nix

    ../home/languages/java.nix
    ../home/languages/node.nix
    ../home/languages/python.nix
  ];
}
