{ lib, inputs, ... }:
let
  utils = inputs.utils.outputs;
in
lib.recursiveUpdate {
  # Stolen from quantumcoded @ https://github.com/QuantumCoded/nixos/blob/master/flake-parts/libraries/combine-modules.nix
  combineModules = modules:
    lib.attrValues (lib.filterAttrs (k: _: k != "default") modules);

  # TODO: Decide on a format (this will change a lot)
  combineModulesExcept = exceptions: modules:
    lib.flatten (map
      (exception: lib.attrValues
        (lib.filterAttrs (k: _: (k != "default") && (k != exception)) modules))
      exceptions);
} utils
