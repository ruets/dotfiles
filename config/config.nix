{ config, pkgs, ... }:

let
  user = let
    envUser = builtins.getEnv "USER";
  in
    if envUser == "" then "ruets" else envUser;
in{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "24.11";
    username = user;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
    language.base = "fr_FR.UTF-8";
  };

  nix = {
    package = pkgs.nixStable;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
