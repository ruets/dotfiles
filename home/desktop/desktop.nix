{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    inputs.hyprconfig.homeManagerModules.default
  ];

  programs = {
    rofi = {
      enable = true;
    };
    wlogout = {
      enable = true;
    };
    r-hyprconfig = {
      enable = true;
    };
  };

  home.packages = with pkgs; let
    gl = config.lib.nixGL.wrap;
  in [
    (gl hyprland)
    hyprpaper
    hyprshade
    hyprmon
    hyprpanel
# ashell

    # hyprlock
    # hypridle
    brightnessctl
    pipewire
    wireplumber

    cliphist

    waypaper
    nwg-dock-hyprland
    smile

    dunst

    eog
    meld
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
    };

    activation = {
      cache = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${config.home.homeDirectory}/.cache/dotfiles
      '';
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
  };
}
