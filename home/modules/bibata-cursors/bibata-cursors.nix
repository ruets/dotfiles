{ lib, pkgs, ... }:

{
  # Bibata cursor theme configuration
  # This is only enabled on Linux systems.
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [ pkgs.bibata-cursors ];

    home.pointerCursor = {
      name = "Bibata-Modern-Classic";
      size = 24;
      package = pkgs.bibata-cursors;
      gtk.enable = true;
      x11.enable = true;
    };

    home.sessionVariables = {
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
    };
  };
}
