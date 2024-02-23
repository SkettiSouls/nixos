{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.hardware.bluetooth;
in
{
  options.shit.hardware.bluetooth = {
    enable = mkEnableOption "desc";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [];

    hardware = {
      bluetooth = {
        enable = true;
	powerOnBoot = true;
	#input = { };
	#settings = { };
	#disabledPlugins = [ ];
      };
    };
  };
}
