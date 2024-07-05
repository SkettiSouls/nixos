# Stolen from quantumcoded @ (https://github.com/QuantumCoded/nixos/blob/master/flake-parts/libraries/combine-modules.nix)
{ lib, ... }:
let
  inherit (builtins)
    attrValues
    ;

  inherit (lib)
    filterAttrs
    ;
in
modules: attrValues (filterAttrs (k: _: k != "default") modules)
