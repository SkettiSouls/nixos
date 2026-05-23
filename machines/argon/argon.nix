{ config, ... }:
let
  inherit (config.flake.lib) mkUsers;
  inherit (config.flake.modules) bundles hardware networks;

  system = "x86_64-linux";
in {
  flake.machines.argon = {
    inherit system;
    hardware = with hardware; [ amd.gpu bluetooth gamepads usb ];
    networks = with networks; [ peridot ];

    users = mkUsers system {
      inherit (config.flake.users) skettisouls;
    };

    modules = [
      bundles.desktop
      bundles.workstation

      ({ pkgs, ... }:
      {
        boot.kernelPackages = pkgs.linuxPackages_latest;
        hardware.enableRedistributableFirmware = true;

        environment.systemPackages = with pkgs; [ bottom ouch ];
        xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

        services.flatpak.enable = true;

        system.stateVersion = "24.11";
      })
    ];
  };
}
