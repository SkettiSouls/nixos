{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  moduleOption = lib.mkOptionType {
    name = "option";
    description = "module option";
    check = x: x._type == "option";
    merge = lib.options.mergeEqualOption;
  };
in
{
  options.flake = {
    modules = mkOption {
      default = {};
      type = with types; lazyAttrsOf (lazyAttrsOf unspecified);
    };

    sharedOptions = mkOption {
      default = {};
      type = types.attrsOf moduleOption;
    };

    types = mkOption {
      default = {};
      type = with types; attrsOf optionType;
    };

    wrappers = mkOption {
      readOnly = true;
      type = with types; attrsOf (attrsOf (attrsOf package)); # Lol
      description = ''
        Re-export of all wrappers for more convenient use with the `nix` command.
        Structured as either `wrappers.<machine>.<user>.<package>` or `wrappers.<user>.<system>.<package>`.
      '';
    };
  };

  config.flake = {
    types.option = moduleOption;
    wrappers = with lib; lib.mkMerge [
      (mapAttrs (_: system: mapAttrs (_: cfg: cfg.wrappers) system) config.flake.users)
      (mapAttrs (_: machine: mapAttrs (_: cfg: cfg.wrappers) machine.users) config.flake.machines)
    ];
  };
}
