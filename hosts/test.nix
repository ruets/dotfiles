{ config, pkgs, ... }:

let
  username = "ruets";
  homeDirectory = "/home/ruets";
  gitUserName = "ruets";
  gitUserEmail = "dev@ruets.pro";
in {
  imports = [
    ../home/cli/cli.nix
    ../home/desktop/desktop.nix

    ../home/modules/wallpapers.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
  ];

  home = {
    username = username;
    homeDirectory = homeDirectory;

    packages = with pkgs; [
      _1password-gui
    ];
  };

programs = {
  git = {
      settings = {
        user = {
          name = gitUserName;
          email = gitUserEmail;
        };
      };
    };
  };
}
