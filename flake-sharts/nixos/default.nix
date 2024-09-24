{ config, lib, ... }:
let
  inherit (config.flake.lib)
    combineModulesExcept
    ;
in
{
  flake.nixosModules = {
    systemd-boot = import ./modules/systemd-boot.nix;

    pipewire = import ./modules/pipewire.nix;
    steam = import ./modules/steam.nix;

    roles = config.flake.roles.default;

    # Stolen from lunarix
    # Pass config.flake down to nixos scope
    stretch = {
      options.flake = lib.mkOption {
        type = lib.types.unspecified;
        default = config.flake;
        readOnly = true;
      };
    };

    default.imports = combineModulesExcept config.flake.nixosModules "home-manager";
  };
}
