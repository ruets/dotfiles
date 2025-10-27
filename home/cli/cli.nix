{ config, pkgs, ... }:

let
  npm_tools = pkgs.callPackage ./npm_tools {};
in
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

    codex.enable = true;
    # claude-code.enable = true;
    gemini-cli.enable = true;

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
    npm_tools

    less
    csvlens
    gum
    libqalculate

    #distant
    w3m
    nnn
    dua
    posting

    gcc
    jq

    xclip
    gitleaks
    lazycli
    commitizen

    cmatrix

    _1password-cli
    spotify-player
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    fprintd
  ];

  home.file = {
    ".config/fish/" = {
      source = ./fish;
      recursive = true;
    };

    ".config/fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;

    ".config/starship/starship.toml".source = ./starship/starship.toml;

    ".config/wal/templates".source = ./wal/templates;

    ".config/nvim/".source = ./nvim;

    ".config/htop/htoprc".source = ./htop/htoprc;
  };
}
