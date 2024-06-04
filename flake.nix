{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    vesktop.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lynx.url = "github:the-computer-club/lynx";
    asluni.url = "github:the-computer-club/automous-zones";
    neovim.url = "github:skettisouls/neovim";
    hyprland.url = "github:hyprwm/hyprland/v0.40.0";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    schizofox.url = "github:schizofox/schizofox";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-parts, lynx, asluni, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
    {
      imports = [
        lynx.flakeModules.flake-guard
        asluni.flakeModules.asluni
      ];

      wireguard.enable = true;
      wireguard.networks.asluni.peers.by-name.argon = {
        privateKeyFile = "/var/lib/wireguard/privatekey";
      };

      systems = [
        "x86_64-linux"
      ];

      flake = {
        nixosConfigurations = {
          argon = nixpkgs.lib.nixosSystem rec {
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
                home-manager.backupFileExtension = "bak";
                home-manager.extraSpecialArgs = specialArgs;
              }
            ];
          };
        };

        homeConfigurations = {
          "skettisouls@argon" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              ./home.nix
            ];
          };
        };
      };

      perSystem = { config, lib, pkgs, ... }: {
        packages = {
          connect-headphones = pkgs.callPackage ./packages/connect-headphones {};
          eat = pkgs.callPackage ./packages/eat {};
          play = pkgs.callPackage ./packages/play {};
        };
      };
    };
}
