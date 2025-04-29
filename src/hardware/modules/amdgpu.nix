{ pkgs, ... }:

{
  config = {
    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ mesa libva ];
      extraPackages32 = [ pkgs.driversi686Linux.mesa ];
    };
  };
}
