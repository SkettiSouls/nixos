{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.fetch;
  #isActiveSet = cfg.active != null;
  contains = list: value: builtins.any (x: x == value) list;
in
{
  options.shit.fetch = {
    active = mkOption {
      type = with types; nullOr (listOf package);
      default = null;
    };
  };

  config = mkIf (cfg.active != null) {
    home.packages = cfg.active;
    kalyx.neofetch.enable = mkIf (contains cfg.active pkgs.neofetch) true;
  };
}
