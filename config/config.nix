{ config, pkgs, inputs, ... }:

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

  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];
}
