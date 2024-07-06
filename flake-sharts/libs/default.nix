{ lib, ... }:
let
  inherit (builtins)
    attrValues
    ;

  inherit (lib)
    filterAttrs
    ;
in
{
  flake = {
    lib = {
      combineModules = import ./combine-modules.nix { inherit lib; };
      combineModulesExcept = modules: exception: attrValues (filterAttrs (k: _: (k != "default") && (k != exception)) modules);

      listToAttrs' = builtins.foldl' (acc: attr: acc // attr) {};
    };
  };
}
