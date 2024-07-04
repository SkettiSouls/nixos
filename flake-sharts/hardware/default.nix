_: {config, inputs, ...}:

let
  inherit (config.flake.lib)
    combineModules
    ;

in
{
  config.flake = {
    nixosModules = {
      # GPUs
      amdgpu = import ./modules/amdgpu.nix;
      nvidia = import ./modules/nvidia.nix;

      # Misc
      bluetooth = import ./modules/bluetooth.nix;
      laptop = import ./modules/laptop.nix;
      monitors = import ./modules/monitors.nix;

      default.imports = combineModules config.flake.nixosModules;
    };

    hardwareModules = {
      argon = import ./modules/machines/argon.nix;
      fluorine = import ./modules/machines/fluorine.nix;
      victus = import ./modules/machines/victus.nix;
    };
  };
}
