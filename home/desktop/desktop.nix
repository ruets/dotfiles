{ inputs, config, pkgs, lib, ... }:
let
  swaylockEffectsNoPam = pkgs.swaylock-effects.overrideAttrs (oldAttrs: {
    mesonFlags = builtins.filter (flag: flag != "-Dpam=enabled") oldAttrs.mesonFlags ++ [
      "-Dpam=disabled"
    ];

    buildInputs =
      [ pkgs.libxcrypt ]
      ++ builtins.filter (p: p != pkgs.pam) oldAttrs.buildInputs;
  });
in
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

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap hyprland)
    hyprpaper
    hyprshade
    hyprmon
    hyprpanel
    # ashell

    hypridle
    # hyprlock
    # swaylock
    # swaylock-effects
    swaylockEffectsNoPam

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
      swaylockSetuid = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        swaylockPath=${swaylockEffectsNoPam}/bin/swaylock
        if [ ! -u "$swaylockPath" ]; then
          echo "Le bit SetUID n'est pas positionné. Application des permissions..."
          # /bin/sudo /bin/chown root:root "$swaylockPath"
          /bin/sudo /bin/chmod a+s "$swaylockPath"
          echo "--- Succès : Bit SetUID appliqué à $swaylockPath. ---";
        else
          echo "Le bit SetUID est déjà positionné sur $swaylockPath. Aucune action requise."
        fi
      '';
    };
  };
}
