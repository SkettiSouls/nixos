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
    enable = mkEnableOption "Bluetooth";
  };

  config = mkIf cfg.enable {
    # TODO: Make bluetooth a feature instead of a hardware module.
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
