{ config, pkgs, inputs, ... }:

let
  nixGLModule = pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
    nixGL = {
      packages = inputs.nixgl.packages;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
  };
in
{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "24.11";
    language.base = "fr_FR.UTF-8";
  };

  nix = {
    package = pkgs.nixStable;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
