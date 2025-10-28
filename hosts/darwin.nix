{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix

    ../home/cli/cli.nix

    ../home/modules/wallpapers/wallpapers.nix

    ../home/softwares/1password/1password.nix
    ../home/softwares/discord/discord.nix
    ../home/softwares/google-chrome/google-chrome.nix
    ../home/softwares/kitty/kitty.nix
    ../home/softwares/notion/notion.nix
    ../home/softwares/qbittorrent/qbittorrent.nix
    ../home/softwares/qualculate/qalculate.nix
    ../home/softwares/scrcpy/scrcpy.nix
    ../home/softwares/spotify/spotify.nix
    ../home/softwares/zathura/zathura.nix

    ../home/languages/java.nix
    ../home/languages/node.nix
    ../home/languages/python.nix
    # ../home/languages/texlive.nix
  ];

  home.username = "ruets";
  home.homeDirectory = "/Users/ruets";
}
