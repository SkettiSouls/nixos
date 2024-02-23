{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.hardware.fstab;
in
{
  options.shit.hardware.fstab = {
    enable = mkEnableOption "Drive Mounting Configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [];

    fileSystems."/" =
      {
        # Nix Store
        device = "/dev/disk/by-uuid/51fce10e-1c6a-4352-bfce-ca6f89b0403c";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      {
        # Boot Partition
        device = "/dev/disk/by-uuid/1C54-88CC";
        fsType = "vfat";
      };
    fileSystems."/home/skettisouls/Games" =
      {
        # 3.6T Storage Partition
        device = "/dev/disk/by-uuid/956d71dc-6837-45bf-b827-c484dee23e90";
        fsType = "btrfs";
      };

    swapDevices = [ 
      {
        # 48G Swap Partition
        device = "/dev/disk/by-uuid/a7a24807-1f25-4d1e-a70d-b518d24a1e3f";
      }
    ];
  };
}
