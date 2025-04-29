{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.unstable.linuxPackages_6_14;
  hardware.enableRedistributableFirmware = true;

  # TODO: Find a way to move this to hm
  services.flatpak.enable = true;

  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  time.timeZone = "America/Chicago";
  system.stateVersion = "24.11";
}
