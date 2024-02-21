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
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ladspaH
      ladspa-sdk
      ladspaPlugins
      rnnoise-plugin
    ];

    symlinkJoin = { 
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
