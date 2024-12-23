{ config, ... }:
let
  inherit (config.flake.lib) combineModules;
in
{
  flake = {
    roles = {
      desktop = ./modules/desktop.nix;
      gaming = ./modules/gaming.nix;
      options = import ./modules/options.nix;
      server = ./modules/server.nix;
      workstation = ./modules/workstation.nix;

      default.imports = combineModules config.flake.roles;
    };
  };
}
