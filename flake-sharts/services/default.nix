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
        discord-bots = import ./modules/discord-bots/service.nix;
        caddy = import ./modules/caddy.nix;
        deemix = import ./modules/deemix/service.nix;
        forgejo = import ./modules/forgejo.nix;
        invidious = import ./modules/invidious.nix;
        minecraft = import ./modules/minecraft.nix;
        navidrome = import ./modules/navidrome.nix;
        nginx = import ./modules/nginx.nix;
        postgres = import ./modules/postgres.nix;
      };

      nixosModules = {
        deemix = import ./modules/deemix/nixos.nix;
        discord-bots = import ./modules/discord-bots/nixos.nix;
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
