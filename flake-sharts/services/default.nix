{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options.flake.serviceModules = mkOption {
    type = with types; attrsOf deferredModule;
    default = {};
  };

  config = {
    flake = {
      serviceModules = {
        airsonic = import ./modules/airsonic/service.nix;
        caddy = import ./modules/caddy.nix;
        deemix = import ./modules/deemix/service.nix;
        forgejo = import ./modules/forgejo.nix;
        invidious = import ./modules/invidious.nix;
        nginx = import ./modules/nginx.nix;
        postgres = import ./modules/postgres.nix;
        terraFirmaGreg = import ./modules/minecraft/terrafirmagreg/service.nix;
      };

      nixosModules = {
        deemix = import ./modules/deemix/nixos.nix;
        terraFirmaGreg = import ./modules/minecraft/terrafirmagreg/nixos.nix;
      };
    };

    perSystem = { pkgs, ... }: {
      packages = {
        airsonic-advanced = pkgs.callPackage ./modules/airsonic/package.nix {};
        deemix-server = pkgs.callPackage ./modules/deemix/package.nix {};
        terraFirmaGreg = pkgs.callPackage ./modules/minecraft/terrafirmagreg/package.nix {};
      };
    };
  };
}
