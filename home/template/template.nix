{ config, pkgs, ... }:
# let
#   gl = config.lib.nixGL.wrap;
# in
{
  programs = {
    PROGRAM.enable = true;

    PROGRAM = {
      enable = true;
      # package = gl pkgs.PRGRM;
      extraConfig = ''
        EXTRA_CONFIG
      '';
    };
  };

  home.packages = with pkgs; [
    PACKAGE
    # (gl pkgs.PACKAGE)
  ];

  home.file = {
    ".config/APP_DIR/".source = ./APP_DIR;

    ".config/APP_DIR/CONFIG_FILE" = {
      source = ./APP_DIR/CONFIG_FILE;
      recursive = true;
    };
  };
}
