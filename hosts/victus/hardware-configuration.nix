{ config, lib, pkgs, modulesPath, ... }:

{
  shit.hardware = {
    bluetooth.enable = true;
    nvidia.enable = true;
    laptop = true;

    monitors = [
      {
        primary = true;
        displayPort = "eDP-1";
        resolution = "1920x1080";
        refreshRate = 144;
        position = "0x0";
        scale = 1;
        lidSwitch = "1fae3b0";
      }
    ];
  };
  # hardware-configuration.nix {{{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";

    offload = {
      enable = true;
      # Run `nvidia-offload <CMD>` to use dGPU.
      enableOffloadCmd = true;
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ee1c930c-b331-4000-9bfb-36db4cdf74e0";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/435E-716C";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/8e925d14-3519-4f7d-a7f5-1f5b5aa94ae6"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # }}}
}
