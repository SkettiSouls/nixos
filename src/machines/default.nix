{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  readDirs = lib.filterAttrs (_: v: v == "directory") (builtins.readDir ./.);
  getConfig = machine: with builtins; map (file: ./${machine}/${file}) (filter (lib.hasSuffix "nix") (attrNames (readDir ./${machine})));
  getConfigs = lib.mapAttrs (machine: _: { imports = getConfig machine; }) readDirs;
in
{
  options.flake.machines = mkOption {
    type = with types; attrsOf deferredModule;
  };

  config.flake.machines = getConfigs;
}
