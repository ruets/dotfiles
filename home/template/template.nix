{ config, pkgs, ... }:

{
  programs = {
    PROGRAM.enable = true;

    PROGRAM = {
      enable = true;
      extraConfig = ''
        EXTRA_CONFIG
      '';
    };
  };

  home.packages = with pkgs; [
    PACKAGES
  ];

  home.file = {
    ".config/APP_DIR/" = {
      enable = true;
      source = ./APP_DIR;
    };

    ".config/APP_DIR/CONFIG_FILE" = {
      enable = true;
      source = ./APP_DIR/CONFIG_FILE;
    };
  };
}
