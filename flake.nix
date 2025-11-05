{
  description = "Home Manager configuration of ruets";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
    };

    wallpapers = {
      url = "github:mylinuxforwork/wallpapers";
      flake = false;
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprconfig = {
      url = "github:olafkfreund/r-hyprconfig";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixgl, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      homeConfigurations =
        let
          mkHome = host: system:
            home-manager.lib.homeManagerConfiguration {
              pkgs = pkgs.${system};
              extraSpecialArgs = { inherit inputs; };
              modules = [
                # (if system == "aarch64-darwin" then inputs.mac-app-util.homeManagerModules.default else null)
                ./hosts/${host}.nix
              ];
            };
        in
        {
          "hostinger" = mkHome "hostinger"  "x86_64-linux";
          "macbook"   = mkHome "macbook"    "aarch64-darwin";
          "work"      = mkHome "work"       "x86_64-linux";
        };
    };
}
