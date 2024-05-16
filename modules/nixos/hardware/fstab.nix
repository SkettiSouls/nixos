{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.hardware.fstab;
in
{
  options.shit.hardware.fstab = {
    enable = mkEnableOption "Drive Mounting Configuration";
  };

  config = mkIf cfg.enable {
    fileSystems."/home/skettisouls/Games" = {
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
