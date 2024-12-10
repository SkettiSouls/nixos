{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.regolith.hardware.amdgpu;
in
{
  options.regolith.hardware.amdgpu = {
    enable = mkEnableOption "AMDGPU";
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [ pkgs.mesa pkgs.libva ];
        extraPackages32 = [ pkgs.driversi686Linux.mesa ];
      };
    };
  };
}
