{
  config.flake.hardwareModules = {
    gpu.amd = import ./modules/amdgpu.nix;
    usb = import ./modules/usb.nix;
    bluetooth = import ./modules/bluetooth.nix;
  };
}
