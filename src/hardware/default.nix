{
  config.flake = {
    nixosModules = {
      # GPUs
      amdgpu = import ./modules/amdgpu.nix;
      nvidia = import ./modules/nvidia.nix;

      # Misc
      bluetooth = import ./modules/bluetooth.nix;
      laptop = import ./modules/laptop.nix;
    };
  };
}
