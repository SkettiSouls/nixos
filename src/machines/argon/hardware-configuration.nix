{ config, lib, pkgs, modulesPath, ... }:

{
  shit.hardware = {
    amdgpu.enable = true;
    bluetooth.enable = true;

    monitors = [
      {
        primary = true;
        displayPort = "HDMI-A-1";
        resolution = "1920x1080";
        refreshRate = 60;
        scale = 1;
      }
    ];
  };

  # hardware-configuration.nix {{{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/1C54-88CC";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-uuid/51fce10e-1c6a-4352-bfce-ca6f89b0403c";
      fsType = "ext4";
    };

    "/home/skettisouls/Games" = {
      # 3.6T Storage Partition
      device = "/dev/disk/by-uuid/956d71dc-6837-45bf-b827-c484dee23e90";
      fsType = "btrfs";
    };
  };

  swapDevices = [
    {
      # 48G Swap Partition
      device = "/dev/disk/by-uuid/a7a24807-1f25-4d1e-a70d-b518d24a1e3f";
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp37s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # }}}
}
