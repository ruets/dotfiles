{
  description = "Home Manager configuration of ruets";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      homeConfigurations = {
        gui = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/gui.nix
          ];
        };
        cli = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/cli.nix
          ];
        };
        hostinger = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/hostinger.nix
          ];
        };
        wsl = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/wsl.nix
          ];
        };
      };
    };
}
