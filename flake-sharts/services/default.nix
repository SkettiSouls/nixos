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
        invidious = import ./modules/invidious.nix;
        nginx = import ./modules/nginx.nix;
        postgres = import ./modules/postgres.nix;
      };

      nixosModules = {
        deemix = import ./modules/deemix/nixos.nix;
      };
    };

    perSystem = { pkgs, ... }: {
      packages = {
        airsonic-advanced = pkgs.callPackage ./modules/airsonic/package.nix {};
        deemix-server = pkgs.callPackage ./modules/deemix/package.nix {};
      };
    };
  };
}
