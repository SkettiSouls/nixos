_: {config, inputs, ...}:

let
  inherit (config.flake.lib)
    combineModules
    ;

in
{
  flake.nixosModules = {

    default.imports = combineModules config.flake.nixosModules;
  };
}
