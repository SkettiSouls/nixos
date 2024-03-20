{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.hardware.cpu;
in
{
  options.shit.hardware.cpu = {
    enable = mkEnableOption "AMD CPU Config";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ];

    hardware.cpu.amd = {
      updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    boot = {
      kernelModules = [ "kvm-amd" ];
    };
  };
}
