{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.hardware.bluetooth;
in
{
  options.shit.hardware.bluetooth = {
    enable = mkEnableOption "BlueTooth";
  };

  config = mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
        package = pkgs.bluez;
        powerOnBoot = true;
        #input = { };
        #settings = { };
        #disabledPlugins = [ ];
      };
    };
  };
}
