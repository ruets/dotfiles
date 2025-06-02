{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    1password
  ];
}
