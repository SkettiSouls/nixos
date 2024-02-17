{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.anoise;
in
{
  options.shit.anoise = {
    enable = mkEnableOption "Noise Cancelling Preset";
    bypass = mkEnableOption "Noise Cancelling Bypass";
  };

  config = mkIf cfg.enable { 
    dconf.settings = {
      "com/gitgub/wwmm/easyeffects/rnnoise" = {
        input-gain = 0; # -36 Db to 36 Db
	output-gain = 0; # -36 Db to 36 Db
	enable-vad = true; # Voice Detection
	vad-thres = 50;
	wet = 0.0; # -100 Db to 20 Db
	release = 20.0; # 0 ms to 20000 ms
	model-path = "";
	bypass = cfg.bypass;
      };
    };
  };
}
