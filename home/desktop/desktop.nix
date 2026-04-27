{ inputs, config, pkgs, lib, ... }:
let
  mkConfigSymlinks = (import ../../lib/mkConfigSymlinks.nix lib).mkConfigSymlinks;

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
    r-hyprconfig = {
      enable = true;
    };

    kitty = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.kitty;
      extraConfig = ''
        #    __ ___ __  __
        #   / //_(_) /_/ /___ __
        #  / ,< / / __/ __/ // /
        # /_/|_/_/\__/\__/\_, /
        #                /___/
        #
        # Configuration
        font_family                 FiraCode Nerd Font
        font_size	                  12
        bold_font                   auto
        italic_font                 auto
        bold_italic_font            auto
        remember_window_size        no
        initial_window_width        950
        initial_window_height       500
        cursor_blink_interval       0.5
        cursor_stop_blinking_after  1
        scrollback_lines            2000
        wheel_scroll_min_lines      1
        enable_audio_bell           no
        window_padding_width        10
        hide_window_decorations     yes
        background_opacity          0.7
        dynamic_background_opacity  yes
        # confirm_os_window_close     0
        selection_foreground        none
        selection_background        none

        # Include pywal colors
        # include $HOME/.cache/wal/colors-kitty.conf

        # Include Custom Configuration
        # Create the file custom.conf in ~/.config/kitty to overwrite the default configuration
        # include ./custom.conf
      '';
    };
  };

  home.packages = with pkgs; [
    zathura
    cava
    rofi
    wlogout

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    fira

    bibata-cursors

    (config.lib.nixGL.wrap hyprland)
    hyprpaper
    awww
    hyprshade
    hyprmon
    hyprpanel
    # ashell
    hyprpicker

    pipewire
    wireplumber
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk

    hypridle
    # hyprlock
    # swaylock
    # swaylock-effects
    swaylockEffectsNoPam

    sass
    kooha
    freerdp

    brightnessctl
    pipewire
    wireplumber

    cliphist
    grimblast
    # hdrop
    # scratchpad

    waypaper
    nwg-dock-hyprland
    smile
    swappy
    pinta
    mission-center
    mpv

    dunst
    showmethekey
    solaar

    eog
    meld
  ];

  home = {
    pointerCursor = {
      name = "Bibata-Modern-Classic";
      size = 24;
      package = pkgs.bibata-cursors;
      gtk.enable = true;
      x11.enable = true;
    };

    sessionVariables = {
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };

    file = {
      ".config/systemd/user/pipewire.service".source = "${pkgs.pipewire}/share/systemd/user/pipewire.service";
      ".config/systemd/user/pipewire.socket".source = "${pkgs.pipewire}/share/systemd/user/pipewire.socket";
      ".config/systemd/user/wireplumber.service".source = "${pkgs.wireplumber}/share/systemd/user/wireplumber.service";
      ".config/systemd/user/xdg-desktop-portal.service".source = "${pkgs.xdg-desktop-portal}/share/systemd/user/xdg-desktop-portal.service";
      ".config/systemd/user/xdg-desktop-portal-hyprland.service".source = "${pkgs.xdg-desktop-portal-hyprland}/share/systemd/user/xdg-desktop-portal-hyprland.service";
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

  systemd = {
    user = {
      targets = {
        desktop-portals = {
          Unit = {
            Description = "Desktop Portals and PipeWire";
            After = [ "dbus.service" ];
            Wants = [
              "pipewire.service"
              "wireplumber.service"
              "xdg-desktop-portal.service"
              "xdg-desktop-portal-hyprland.service"
            ];
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    };
  };

  xdg.configFile = mkConfigSymlinks {
    inherit config;
    srcPath    = ./config;
    srcAbsPath = "${config.home.homeDirectory}/.config/home-manager/home/desktop/config";
  };
}
