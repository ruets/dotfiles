{ config, pkgs, ... }:

{
  imports = [
    ../home/cli/cli.nix
    ../home/desktop/desktop.nix

    ../home/modules/wallpapers.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
  ];

  home = {
    username = "ruets";
    homeDirectory = "/home/ruets";

    packages = with pkgs; [
      _1password-gui
    ];
  };
}
