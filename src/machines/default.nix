{ config, lib, ... }:
let
  inherit (config.flake.lib) listToAttrs';

  inherit (lib)
    mkOption
    types
    ;

  getConfig = machine: { imports = [ ./${machine}/configuration.nix ./${machine}/hardware-configuration.nix ]; };
  getConfigs = machines: listToAttrs' (map (machine: { ${machine} = getConfig machine; }) machines);
in
{
  options.flake = {
    machines = mkOption {
      type = with types; attrsOf deferredModule;
    };
  };

  config.flake = {
    machines = getConfigs [
      "argon"
      "fluorine"
      "victus"
    ];
  };
}
