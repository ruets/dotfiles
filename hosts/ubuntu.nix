{ config, pkgs, ... }:

{
  imports = [
    ../home/cli/cli.nix
    ../home/desktop/desktop.nix

    ../home/modules/wallpapers.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
    ../home/languages/texlive.nix
  ];

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
  };

  home = {
    username = "sruet";
    homeDirectory = "/home/sruet";

    packages = with pkgs; [
      _1password-gui
      discord
      google-chrome
      qbittorrent
      spotify
      scrcpy
      waydroid

      jetbrains-toolbox
    ];
  };
}
