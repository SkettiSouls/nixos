{ lib, ... }:
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
  };

  config.flake.types.option = moduleOption;
}
