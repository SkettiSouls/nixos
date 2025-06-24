{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_6_14;
  hardware.enableRedistributableFirmware = true;

  regolith = {
    hyprland = {
      enable = true;
      matchMesaVersion = true;
      withUWSM = true;
    };

    niri = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };

  # TODO: Find a way to move this to hm
  services.flatpak.enable = true;

  time.timeZone = "America/Chicago";
  system.stateVersion = "24.11";
}
