{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix

    ../home/cli/cli.nix

    ../home/softwares/video2midi/video2midi.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
    ../home/languages/rust.nix
    ../home/languages/texlive.nix
  ];
}
