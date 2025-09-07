{ config, pkgs, inputs, ... }:

{
  home.file = {
    "wallpapers" = {
      source = inputs.wallpapers;
      recursive = true;
    };
  };
}

