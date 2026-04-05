{ config, pkgs, lib, ... }:
let
  mkConfigSymlinks = (import ../../lib/mkConfigSymlinks.nix lib).mkConfigSymlinks;
in

{
  programs = {
    git = {
      enable = true;
      lfs.enable = true;

      settings = {
        core.editor = "nvim";
        init = { defaultBranch = "main"; };
      };
    };

    gh = {
      enable = true;
      extensions = [
        # pkgs.gh-copilot
        # pkgs.gh-dash
        # pkgs.gh-markdown-preview
        # pkgs.gh-eco
        # pkgs.gh-branch
        # pkgs.gh-notify
        # pkgs.gh-cp
        # pkgs.gh-lazy
        # pkgs.gh-repo-stats

      ];
    };
  };

  home.packages = with pkgs; [
    fish
    fastfetch
    starship
    pywal
    eza
    bat

    tmux

    neovim
    ripgrep
    fzf
    fd

    ranger
    lazygit
    htop
    btop

    codex
    claude-code
    gemini-cli

    # gallery-dl

    gitnr
    android-tools
    lyto
    less
    csvlens
    gum
    libqalculate

    #distant
    yazi
    w3m
    nnn
    dua
    posting

    pandoc
    go-grip
    sqlite

    gcc
    jq
    hyperfine

    xclip
    gitleaks
    lazycli
    commitizen

    cmatrix

    spotify-player
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    fprintd
    tty-clock
    acpi
  ];

  xdg.configFile = mkConfigSymlinks {
    inherit config;
    srcPath    = ./config;
    srcAbsPath = "${config.home.homeDirectory}/.config/home-manager/home/cli/config";
  };
}
