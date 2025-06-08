{ pkgs, lib, ... }:

{
  config = {
    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      package = lib.mkDefault pkgs.mesa;
      package32 = lib.mkDefault pkgs.driversi686Linux.mesa;
      extraPackages = with pkgs; [ libva ];
    };
  };
}
