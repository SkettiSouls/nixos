{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    hm-unstable.url = "github:nix-community/home-manager/master";
    hyprland.url = "github:hyprwm/hyprland";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ { nixpkgs, home-manager, self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      flake = {
        nixosConfigurations = {
          goatware = nixpkgs.lib.nixosSystem rec {
            specialArgs = { inherit inputs self; };
            modules = [
              ./configuration.nix
              home-manager.nixosModules.home-manager

              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.skettisouls = import ./home.nix;
                home-manager.extraSpecialArgs = specialArgs;
              }
            ];
          };
        };

        homeConfigurations = {
          "skettisouls@goatware" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              ./home.nix
            ];
          };
        };
      };

      perSystem = { config, lib, pkgs, ... }: {
        packages = {
          play = pkgs.callPackage ./packages/play { };
        };
      };
    };
}
