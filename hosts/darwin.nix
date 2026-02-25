{ config, pkgs, ... }:

{
  imports = [
    ../home/cli/cli.nix

    ../home/modules/wallpapers.nix

    ../home/languages/node.nix
    ../home/languages/texlive.nix
  ];

  home = {
    username = "ruets";
    homeDirectory = "/Users/ruets";

    packages = with pkgs; [
      _1password-gui
      discord
      google-chrome
      notion-app
      qbittorrent
      spotify

      jetbrains-toolbox

      # skhd
    ];

  # TODO add yabai and move to nix darwin
  file = {
    ".skhdrc".text = ''
      # skhd configuration file
      # Reload skhd configuration
      cmd + alt + ctrl - r : skhd --reload
      # Open kitty terminal
      cmd - return : open -a kitty
    '';
    };
  };

  # launchd.agents.skhd = {
  #   enable = true;
  #   config = {
  #     ProgramArguments = [ "${pkgs.skhd}/bin/skhd" ];
  #     RunAtLoad = true;
  #     KeepAlive = true;
  #   };
  # };

  programs = {
    kitty = {
      enable = true;
      extraConfig = ''
        #    __ ___ __  __
        #   / //_(_) /_/ /___ __
        #  / ,< / / __/ __/ // /
        # /_/|_/_/\__/\__/\_, /
        #                /___/

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
}
