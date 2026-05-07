{
  flake.modules.nixos.systemd-boot =
    { lib, ... }:
    {
      config.boot.loader = lib.mkDefault {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          memtest86.enable = true;
        };
      };
    };
}
