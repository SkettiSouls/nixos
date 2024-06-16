_: {config, inputs, ...}:

let
  inherit (config.flake.lib)
    combineModules
    ;

in
{
  flake.nixosModules = {
    nvidia = import ./modules/nvidia.nix;
    amdgpu = import ./modules/amdgpu.nix;
    bluetooth = import ./modules/bluetooth.nix;
    fstab = import ./modules/fstab.nix;

    default.imports = combineModules config.flake.nixosModules;
  };

  flake.hardwareModules = {
    # TODO: Move each `hardware-configuration.nix` here.
  };
}
