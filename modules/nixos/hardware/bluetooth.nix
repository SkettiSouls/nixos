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
    enable = mkEnableOption "desc";
  };

  config = mkIf cfg.enable {
    hardware = {
      bluetooth = {
        package = pkgs.bluez;
        enable = true;
        powerOnBoot = true;
        #input = { };
        #settings = { };
        #disabledPlugins = [ ];
      };
    };
  };
}
