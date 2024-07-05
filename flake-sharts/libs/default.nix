{ lib, ... }:

{
  flake = {
    lib = {
      combineModules = import ./combine-modules.nix { inherit lib; };

      listToAttrs' = builtins.foldl' (acc: attr: acc // attr) {};
    };
  };
}
