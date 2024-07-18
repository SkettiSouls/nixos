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

  config.flake.serviceModules = {
    postgres = import ./modules/postgres.nix;
  };
}
