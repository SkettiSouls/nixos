{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.boot.systemd;
in
{
  options.shit.boot.systemd.enable = mkEnableOption "Systemd bootloader";

  config.boot.loader = mkIf cfg.enable {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      memtest86.enable = true;
    };
  };
}