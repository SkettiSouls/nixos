{ pkgs, lib, ... }:

{
  config = {
    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      package = pkgs.mesa;
      package32 = pkgs.driversi686Linux.mesa;
      extraPackages = with pkgs; [ libva ];
    };
  };
}
