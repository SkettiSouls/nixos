{ config, ... }:
let
  inherit (config.flake.lib)
    combineModules
    ;
in
{
  flake.roles = {
    desktop = import ./modules/desktop.nix;
    gaming = import ./modules/gaming.nix;
    server = import ./modules/server.nix;
    workstation = import ./modules/workstation.nix;

    default.imports = combineModules config.flake.roles;
  };
}
