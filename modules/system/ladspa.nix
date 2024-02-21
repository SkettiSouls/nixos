{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.ladspa;
in
{
  options.shit.ladspa = {
    enable = mkEnableOption "Ladspa Mega Derivation";
    foo = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    users.users.skettisouls.packages = with pkgs; [
      ladspaH
      ladspa-sdk
      ladspaPlugins
      rnnoise-plugin
    ];

    shit.ladspa.foo = pkgs.symlinkJoin { 
      name = "ladspa-plugins";
      paths = with pkgs; [
        ladspaH
	ladspa-sdk
	ladspaPlugins
	rnnoise-plugin
      ];
      postbuild = "echo links added";
    };
  };
}
