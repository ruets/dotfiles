{ config, pkgs, ... }:

{
  programs = {
    poetry.enable = true;
  };

  home.packages = with pkgs; [
    python3
    pipx
    uv
  ];
}
