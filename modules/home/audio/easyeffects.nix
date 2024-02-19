{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.easyeffects;
in
{
  options.shit.easyeffects = {
    enable = mkEnableOption "EasyEffects";
    bypass = mkEnableOption "Global Bypass";
  };

  config = mkIf cfg.enable {
    services.easyeffects = {
      enable = true;
      preset = "anoise";
    };

    xdg.configFile."easyeffects/input".source = ../../../shit/easyeffects/input;
    #xdg.configFile."easyeffects".source = ../../../shit/easyeffects;

    dconf.settings = {
      "com/github/wwmm/easyeffects" = {
        process-all-outputs = false; # Disable easyeffects sink stealing all audio
	process-all-inputs = true;
	use-dark-theme = true;
	bypass = cfg.bypass;
      };
    };
  };
}
