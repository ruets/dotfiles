{ config, pkgs, ... }:

let
  username = "sruet";
  homeDirectory = "/home/sruet";
  gitUserName = "Sébastien RUET";
  gitUserEmail = "sebastien.ruet@insa-lyon.fr";
in {
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
    homeDirectory = homeDirextory;

    packages = with pkgs; [
      _1password-gui
      _1password-cli
      bitwarden-desktop
      bitwarden-cli

      discord
      google-chrome
      qbittorrent
      spotify
      scrcpy
      waydroid

      jetbrains-toolbox
    ];
  };

  programs = {
    obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi #optional AMD hardware acceleration
        obs-gstreamer
        obs-vkcapture
      ];
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
  };
}
