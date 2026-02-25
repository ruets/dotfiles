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

    codex.enable = true;
    claude-code.enable = true;
    gemini-cli.enable = true;

    # gallery-dl.enable = true;

    git = {
      enable = true;
      lfs.enable = true;

      settings = {
        user = {
          name = "ruets";
          email = "dev@ruets.pro";
        };
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

  home.file = {
    ".config/fish/" = {
      source = ./fish;
      recursive = true;
    };

    ".config/fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;

    ".config/starship/starship.toml".source = ./starship/starship.toml;

    ".config/wal/templates".source = ./wal/templates;

    ".config/nvim/".source = ./nvim;

    ".config/yazi/" = {
      source = ./yazi;
      recursive = true;
    };

    ".config/htop/htoprc".source = ./htop/htoprc;
  };
}
