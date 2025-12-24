{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_6_16;
  hardware.enableRedistributableFirmware = true;

  regolith = {
    hyprland = {
      enable = false;
      matchMesaVersion = true;
      withUWSM = true;
    };

    niri = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      useUnstable = true;
    };

    steam = {
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true; # Used for obs vulkan capture plugin
        };
      };

      protonPackages = with pkgs; [];
    };
  };

  # TODO: Find a way to move this to hm
  services.flatpak.enable = true;

  time.timeZone = "America/Chicago";
  system.stateVersion = "24.11";
}
