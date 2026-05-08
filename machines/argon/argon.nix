{ config, ... }:
let
  inherit (config.flake.lib) mkUsers;
  inherit (config.flake.modules) bundles hardware networks nixos;

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

      nixos.niri

      ({ pkgs, ... }:
      {
        boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
        hardware.enableRedistributableFirmware = true;

        environment.systemPackages = with pkgs; [ bottom ouch ];

        programs.niri.withUWSM = true;
        services.flatpak.enable = true;

        system.stateVersion = "24.11";
      })
    ];
  };
}
