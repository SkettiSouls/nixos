{ config, ... }:
let
  inherit (config.flake.lib)
    combineModulesExcept
    ;
in
{
  flake.nixosModules = {
    pipewire = import ./modules/pipewire.nix;
    steam = import ./modules/steam.nix;

    roles = config.flake.roles.default;
    default.imports = combineModulesExcept config.flake.nixosModules "home-manager";
  };
}
