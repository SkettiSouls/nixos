{
  config.flake.hardwareModules = {
    gpu.amd = import ./modules/amdgpu.nix;
    bluetooth = import ./modules/bluetooth.nix;
  };
}
