{
  description = "Home Manager configuration of ruets";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:mylinuxforwork/wallpapers";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      mkHome = host: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./hosts/${host}.nix ];
      };
    in {
      homeConfigurations = {
        gui       = mkHome "gui";
        cli       = mkHome "cli";
        hostinger = mkHome "hostinger";
        wsl       = mkHome "wsl";
      };
    };
}
