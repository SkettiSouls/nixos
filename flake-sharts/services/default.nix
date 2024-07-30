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
        deemix = import ./modules/deemix/service.nix;
        invidious = import ./modules/invidious.nix;
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
