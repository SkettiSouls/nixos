{ config, lib, ... }:

{
  flake.nixosModules = {
    hyprland = import ./modules/hyprland.nix;
    global = import ./modules/global.nix;
    pipewire = import ./modules/pipewire.nix;
    systemd-boot = import ./modules/systemd-boot.nix;

    # Stolen from lunarix
    # Pass config.flake down to nixos scope
    stretch = {
      options.flake = lib.mkOption {
        type = lib.types.unspecified;
        default = config.flake;
        readOnly = true;
      };
    };
  };
}
