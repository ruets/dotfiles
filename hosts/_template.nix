{ config, pkgs, ... }:
let
  username = "";
  homeDirectory = "";
  gitUserName = "";
  gitUserEmail = "";
  # gl = config.lib.nixGL.wrap;
in {
{
  imports = [
    ../home/cli/cli.nix
    ../home/desktop/desktop.nix

    ../home/modules/wallpapers.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
    ../home/languages/texlive.nix
  ];

  home = {
    username = username;
    homeDirectory = homeDirectory;

    packages = with pkgs; [
      # (gl pkgs.PACKAGE)
      PACKAGE
    ];

    file = {
      ".config/APP_DIR/".source = ./APP_DIR;

      ".config/APP_DIR/CONFIG_FILE" = {
        source = ./APP_DIR/CONFIG_FILE;
        recursive = true;
      };
    };
  };

  programs = {
    PROGRAM.enable = true;

    PROGRAM = {
      enable = true;
      package = gl pkgs.PRGRM;
      extraConfig = ''
        EXTRA_CONFIG
      '';
    };

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
