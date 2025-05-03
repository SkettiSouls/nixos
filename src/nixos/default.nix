{ withArgs, ... }:
{ inputs, config, lib, ... }:

{
  flake.nixosModules = {
    # We use the `inputs` AFTER `importApply` to let inputs vary by flake
    global = withArgs ./modules/global.nix { inherit inputs; };
    hyprland = withArgs ./modules/hyprland.nix {};
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
