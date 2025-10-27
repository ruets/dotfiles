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
  };

  outputs = { self, nixpkgs, home-manager, nixgl, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      homeConfigurations =
        let
          mkHome = username: hostname: system:
            home-manager.lib.homeManagerConfiguration {
              pkgs = pkgs.${system};
              extraSpecialArgs = { inherit inputs; };
              modules = [
                ./hosts/${hostname}.nix
                {
                  home.username = username;
                  home.homeDirectory = if username == "root" then "/root"
                                      else if pkgs.${system}.stdenv.isDarwin then "/Users/${username}"
                                      else "/home/${username}";
                }
              ];
            };
        in
        {
          "cli" = mkHome "ruets" "cli" "x86_64-linux";
          "gui" = mkHome "ruets" "gui" "x86_64-linux";
          "wsl" = mkHome "ruets" "wsl" "x86_64-linux";
          "darwin" = mkHome "ruets" "darwin" "aarch64-darwin";

          "hostinger" = mkHome "root" "hostinger" "x86_64-linux";

          "work" = mkHome "sruet" "work" "x86_64-linux";
        };
    };
}
