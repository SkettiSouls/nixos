{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    hm-unstable.url = "github:nix-community/home-manager/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lynx.url = "github:the-computer-club/lynx";
    asluni.url = "github:the-computer-club/automous-zones";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-parts, lynx, asluni, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
    {
      imports = [
        lynx.flakeModules.flake-guard
        asluni.flakeModules.asluni
      ];

      wireguard.networks.asluni.peers.by-name.goatware = {
        privateKeyFile = /var/lib/wireguard/privatekey;
        publicKey = "...";
        ipv4 = [ "172.16.2.7" ];
      };

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
                imports = [self.nixosModules.flake-guard-host];
                networking.wireguard = {
                  networks.asluni.autoConfig = {
                    interface = true;
                    peers = true;
                  };

                  interfaces.asluni.generatePrivateKeyFile = true;
                };
              }

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
