_: {config, inputs, ...}:

let
  inherit (config.flake.lib)
    combineModules
    ;

in
{
  flake.nixosModules = {
    # GPUs
    amdgpu = import ./modules/amdgpu.nix;
    nvidia = import ./modules/nvidia.nix;

    # Misc
    bluetooth = import ./modules/bluetooth.nix;
    fstab = import ./modules/fstab.nix;
    laptop = import ./modules/laptop.nix;

    # Option Modules
    monitors = import ./options/monitors.nix;

    default.imports = combineModules config.flake.nixosModules;
  };

  flake.hardwareModules = {
    # TODO: Move each `hardware-configuration.nix` here.
  };
}
