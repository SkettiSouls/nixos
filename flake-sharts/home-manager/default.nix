{ config, lib, ... }:
let
  inherit (config.flake.lib)
    combineModules
    ;

  inherit (lib)
    mkOption
    types
    ;
in
{
  imports = [ ./nixos-module.nix ];

  options.flake.homeModules = mkOption {
    type = with types; attrsOf deferredModule;
    default = {};
  };

  config.flake.homeModules = {
    git = ./modules/git.nix;
    peripherals = import ./modules/peripherals.nix;

    # Application modules
    carla = import ./modules/applications/carla.nix;
    mimelist = import ./modules/applications/mimelist.nix;
    neofetch = import ./modules/applications/neofetch;

    default.imports = combineModules config.flake.homeModules;
  };
}
