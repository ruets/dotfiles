{ config, pkgs, inputs, lib, ... }:

{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "24.11";
    language.base = "fr_FR.UTF-8";
  };

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixGL = lib.mkIf pkgs.stdenv.isLinux {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };
}
