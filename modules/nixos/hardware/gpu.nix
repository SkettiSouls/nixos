{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.hardware.gpu;
in
{
  options.shit.hardware.gpu = {
    enable = mkEnableOption "AMDGPU Configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mesa
      libva
    ];

    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true; # Enable 32-Bit Support
        extraPackages = [ pkgs.mesa pkgs.libva ];
        extraPackages32 = [ pkgs.driversi686Linux.mesa ];
      };
    };
  };
}
