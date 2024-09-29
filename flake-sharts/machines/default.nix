{ lib, ... }:
let
  inherit (lib)
    attrNames
    filterAttrs
    hasSuffix
    mkOption
    types
    ;

  # TODO?: Replace flake.lib.listToAttrs' with this
  listToAttrs'' = builtins.foldl' lib.recursiveUpdate {};
  mapModules = {machines, dir ? "homes", users ? []}: listToAttrs'' (lib.flatten
    (map (machine:
      if users != [] then map (user: { ${user}.${machine} = ./homes/${user}/${machine}.nix; }) users
      else { ${machine} = ./${dir}/${machine}.nix; }
    ) machines));

  getFiles = x: attrNames (filterAttrs (n: _: hasSuffix ".nix" n) (builtins.readDir x));
  getMachines = {dir, users ? []}:
    if users != [] then map (lib.removeSuffix ".nix") (lib.concatMap (user: getFiles ./${dir}/${user}) users)
    else map (lib.removeSuffix ".nix") (getFiles ./${dir});
in
{
  options.flake.machines = {
    hardware = mkOption {
      type = with types; attrsOf deferredModule;
      default = {};
    };

    homes = mkOption {
      type = with types; attrsOf (attrsOf deferredModule);
      default = {};
    };

    hosts = mkOption {
      type = with types; attrsOf deferredModule;
      default = {};
    };
  };

  config.flake.machines = {
    hardware = mapModules rec {
      dir = "hardware";
      machines = getMachines { inherit dir; };
    };

    hosts = mapModules rec {
      dir = "hosts";
      machines = getMachines { inherit dir; };
    };

    homes = mapModules rec {
      dir = "homes";
      users = [ "skettisouls" ];
      machines = getMachines { inherit dir users; };
    };
  };
}
