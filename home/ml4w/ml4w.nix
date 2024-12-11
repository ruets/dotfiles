{ config, pkgs, ... }:

{
  home.file = {
    ".config/ml4w/" = {
      enable = true;
      source = ./ml4w;
    };
  };
}
