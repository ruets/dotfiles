{ config, pkgs, ... }:
# let
#   gl = config.lib.nixGL.wrap;
# in
{
  home.packages = with pkgs; [
    bruno
    bruno-cli
  ];
}
