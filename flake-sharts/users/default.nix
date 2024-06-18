_: { config, inputs, ... }:
let
  inherit (config.flake.lib)
    combineModules
    ;
in
{
  config.flake.userModules = {
    skettisouls = import ./skettisouls.nix;

    default.imports = combineModules config.flake.userModules;
  };
}
