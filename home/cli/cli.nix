{ config, pkgs, ... }:

{
  programs = {
    fish.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    pywal.enable = true;
    eza.enable = true;
    bat.enable = true;

    neovim.enable = true;
    ripgrep.enable = true;
    fzf.enable = true;
    fd.enable = true;

    ranger.enable = true;
    lazygit.enable = true;
    htop.enable = true;
    btop.enable = true;

    git = {
      enable = true;
      lfs.enable = true;

      userName = "ruets";
      userEmail = "dev@ruets.pro";

      extraConfig = {
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

    tmux = {
      enable = true;
      extraConfig = ''
        # Enable true colors
        set -g default-terminal "$TERM"
        set -ag terminal-overrides ",$TERM:Tc"

        # Enable mouse mode
        set -g mouse on

        # Start counting pane and window number at 1
        set -g base-index 1
        setw -g pane-base-index 1
      '';
    };
  };

  home.packages = with pkgs; [
    less
    gum
    libqalculate

    #distant
    w3m
    nnn

    gcc
    jq

    # codex
    xclip
    gitleaks
    lazycli
    commitizen

    fprintd
    cmatrix

    _1password-cli
    spotify-player
  ];

  home.file = {
    ".config/fish/" = {
      enable = true;
      source = ./fish;
    };

    ".config/fastfetch/config.jsonc" = {
      enable = true;
      source = ./fastfetch/config.jsonc;
    };

    ".config/starship/starship.toml" = {
      enable = true;
      source = ./starship/starship.toml;
    };

    ".config/wal/templates" = {
      enable = true;
      source = ./wal/templates;
    };

    ".config/nvim/" = {
      enable = true;
      source = ./nvim;
    };

    ".config/htop/htoprc" = {
      enable = true;
      source = ./htop/htoprc;
    };
  };
}
