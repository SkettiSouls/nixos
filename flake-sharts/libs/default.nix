{ lib, ... }:

{
  flake = {
    lib = rec {
      # Stolen from quantumcoded @ (https://github.com/QuantumCoded/nixos/blob/master/flake-parts/libraries/combine-modules.nix)
      combineModules = modules: lib.attrValues (lib.filterAttrs (k: _: k != "default") modules);

      combineModulesExcept = exceptions: modules: lib.flatten (map (exception: lib.attrValues (lib.filterAttrs (k: _: (k != "default") && (k != exception)) modules)) exceptions);

      listToAttrs' = builtins.foldl' (acc: attr: acc // attr) {};

      exponent = n: i:
        if i == 1 then n
        else if i == 0 then 1
        else n * exponent n (i - 1)
        ;

      getAllModules = path: map (file: "${path}/${file}") (builtins.attrNames
        (lib.filterAttrs (n: _: n != "default.nix" && lib.hasSuffix ".nix" n) (builtins.readDir path)));

      getAllDirs = path: map (file: path + "/${file}") (builtins.attrNames
        (lib.filterAttrs (n: t: t == "directory" && n != ".git") (builtins.readDir path)));

      getAllDirsExcept = exceptions: path:
        if builtins.isPath exceptions then 
          lib.remove exceptions (getAllDirs path)
        else if builtins.isList exceptions then 
          lib.foldl' (dirs: except: lib.remove except dirs) (getAllDirs path) exceptions 
        else throw "Exception not of type `either path (listOf path)`";
    };
  };
}
