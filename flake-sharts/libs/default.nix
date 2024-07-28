{ lib, ... }:
let
  inherit (builtins)
    attrValues
    ;

  inherit (lib)
    filterAttrs
    ;

  exponent = n: i:
    if i == 1 then n
    else if i == 0 then 1
    else n * exponent n (i - 1)
    ;
in
{
  flake = {
    lib = {
      combineModules = import ./combine-modules.nix { inherit lib; };
      combineModulesExcept = modules: exception: attrValues (filterAttrs (k: _: (k != "default") && (k != exception)) modules);

      listToAttrs' = builtins.foldl' (acc: attr: acc // attr) {};

      exponent = exponent;
    };
  };
}
