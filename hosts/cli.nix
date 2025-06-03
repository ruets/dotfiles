{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix

    ../home/cli/cli.nix

    ../home/devops/docker/docker.nix

    ../home/languages/node.nix
    ../home/languages/python.nix
    ../home/languages/java.nix
    ../home/languages/rust.nix
    ../home/languages/texlive.nix
  ];
}
