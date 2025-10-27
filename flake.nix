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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      homeConfigurations =
        let
          mkHome = host: system: home-manager.lib.homeManagerConfiguration {
            pkgs = pkgs.${system};
            extraSpecialArgs = { inherit inputs; };
            modules = [ ./hosts/${host}.nix ];
          };
        in
        {
          cli = mkHome "cli" "x86_64-linux";
          gui = mkHome "gui" "x86_64-linux";
          wsl = mkHome "wsl" "x86_64-linux";
          hostinger = mkHome "hostinger" "x86_64-linux";
          darwin = mkHome "darwin" "aarch64-darwin";
        };
    };
}
