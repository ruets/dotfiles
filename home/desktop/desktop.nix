{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    inputs.hyprconfig.homeManagerModules.default
  ];

  programs = {
    rofi = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.rofi;
    };
    wlogout = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.wlogout;
    };
    r-hyprconfig = {
      enable = true;
    };
  };

  home.packages = with pkgs; let
    gl = config.lib.nixGL.wrap;
  in [
    (gl hyprland)
    (gl hyprpaper)
    hyprpanel
    hyprmon
    brightnessctl

    (gl waypaper)
    (gl nwg-dock-hyprland)
    (gl smile)

    (gl dunst)

    (gl eog)
    (gl meld)

    (gl networkmanager)
    # (gl network-manager-applet)
  ];

  home = {
    file = {
      ".config/hypr" = {
        source = ./hypr;
        recursive = true;
      };

      ".config/rofi/".source = ./rofi;
      ".config/wlogout/".source = ./wlogout;
      ".config/waypaper/config.ini".source = ./waypaper/config.ini;
      ".config/nwg-dock-hyprland/".source = ./nwg-dock-hyprland;
      ".config/dunst/dunstrc".source = ./dunst/dunstrc;
      ".config/ml4w/".source = ./ml4w;
    };

    activation = {
      hyprland = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        cp -f ${config.home.homeDirectory}/.config/hypr/hyprland_default.conf \
              ${config.home.homeDirectory}/.config/hypr/hyprland.conf
        chmod +w ${config.home.homeDirectory}/.config/hypr/hyprland.conf
      '';

      # pam-hyprlock = config.lib.dag.entryAfter ["writeBoundary"] ''
      #   echo -----------------------------------------------------------------------
      #   echo Ensure hyprlock PAM configuration exists
      #   echo -----------------------------------------------------------------------
      #   # Symlink the PAM file from the hyprlock package
      #   /bin/sudo /bin/ln -sf ${pkgs.hyprlock}/etc/pam.d/hyprlock /etc/pam.d/hyprlock
      # '';
    };

    sessionVariables = {
      HYPRLAND_CONFIG = "${config.home.homeDirectory}/.config/hypr/conf/monitor.conf";
    };
  };
}
