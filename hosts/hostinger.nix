{ config, pkgs, ... }:

let
  username = "root";
  homeDirectory = "/root";
  gitUserName = "ruets";
  gitUserEmail = "dev@ruets.pro";
in {
  imports = [
    ../home/cli/cli.nix

    ../home/modules/vps.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
  ];

  home = {
    username = username;
    homeDirectory = homeDirectory;
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
