_: {config, inputs, ...}:

let
  inherit (config.flake.lib)
    combineModules
    ;

in
{
  flake.nixosModules = {

    roles = config.flake.roles.default;
    default.imports = combineModules config.flake.nixosModules;
  };
}
