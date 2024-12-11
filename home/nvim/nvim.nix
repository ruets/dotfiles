{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
  };

  home.file = {
    ".config/nvim/" = {
      enable = true;
      source = ./nvim;
    };
  };
}
