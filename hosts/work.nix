{ config, pkgs, ... }:

{
  imports = [
    ../home/cli/cli.nix
    ../home/desktop/desktop.nix

    ../home/modules/wallpapers/wallpapers.nix
    ../home/modules/bibata-cursors/bibata-cursors.nix

    ../home/softwares/1password/1password.nix
    ../home/softwares/bruno/bruno.nix
    ../home/softwares/cava/cava.nix
    ../home/softwares/discord/discord.nix
    ../home/softwares/google-chrome/google-chrome.nix
    ../home/softwares/kitty/kitty.nix
    ../home/softwares/mission-center/mission-center.nix
    ../home/softwares/pinta/pinta.nix
    ../home/softwares/qualculate/qalculate.nix
    ../home/softwares/spotify/spotify.nix
    ../home/softwares/zathura/zathura.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
    ../home/languages/texlive.nix
  ];

  home.username = "sruet";
  home.homeDirectory = "/home/sruet";
}
