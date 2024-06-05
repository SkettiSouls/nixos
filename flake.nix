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
      (args @ { config, flake-parts-lib, ... }:
        let
          inherit (flake-parts-lib) importApply;

          inherit (nixpkgs.lib)
            mapAttrs
            mkOption
            nixosSystem
            types
            ;

          flakeModules = {
            # features = importApply ./flake-sharts/features args;
            # hardware = importApply ./flake-sharts/hardware args;
            # home-manager = importApply ./flake-sharts/home-manager args;
            # hosts = importApply ./flake-sharts/hosts args;
            libs = importApply ./flake-sharts/libs args;
            # nixos = importApply ./flake-sharts/nixos args;
            # packages = importApply ./flake-sharts/packages args;
            # roles = importApply ./flake-sharts/roles args;
            # users = importApply ./flake-sharts/users args;
            wireguard = importApply ./flake-sharts/wireguard args;
          };
        in
        {
          imports = with flakeModules; [
            libs
            wireguard
          ];

          options = {
            nixos = mkOption {
              type = with types; attrsOf unspecified;
              default = {};
            };

            home = mkOption {
              type = with types; attrsOf unspecified;
              default = {};
            };
          };

          config = {
            systems = [
              "x86_64-linux"
            ];

            nixos = {
              argon = ./hosts/argon/configuration.nix; 
              fluorine = ./hosts/fluorine/configuration.nix;
            };

            home = {
              "skettisouls@argon" = ./home;
            };

            flake = {
              inherit flakeModules;

              nixosConfigurations = mapAttrs (name: value: nixosSystem {
                specialArgs = { inherit inputs self; };
                modules = [
                  value
                  ./flake-sharts/wireguard/luni-net.nix
                ];
              }) config.nixos;

              homeConfigurations = mapAttrs (name: value: home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                modules = [ value ];
              }) config.home;
            };

            perSystem = { config, lib, pkgs, ... }: {
              packages = {
                connect-headphones = pkgs.callPackage ./packages/connect-headphones {};
                eat = pkgs.callPackage ./packages/eat {};
                play = pkgs.callPackage ./packages/play {};
              };
            };
          };
        });

}
