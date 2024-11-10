{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  # TODO: Replace flake.lib.listToAttrs' with this
  listToAttrs'' = builtins.foldl' lib.recursiveUpdate {};
in
{
  options.flake = {
    machines = mkOption {
      type = with types; attrsOf deferredModule;
    };
  };

  config.flake = {
    machines = {
      argon.imports = [
        ./argon/configuration.nix
        ./argon/hardware-configuration.nix
      ];

      fluorine.imports = [
        ./fluorine/configuration.nix
        ./fluorine/hardware-configuration.nix
      ];

      victus.imports = [
        ./victus/configuration.nix
        ./victus/hardware-configuration.nix
      ];
    };
  };
}
