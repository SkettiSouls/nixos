# Credit to kyleraykbs for the entire module
{
  flake.machines.argon.modules = [
    ({ config, lib, ... }:
    {
      boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
      boot.kernelModules = [ "v4l2loopback" ];
      boot.extraModprobeConfig = let
        virtualCamsModprobe = count: let
          ids = lib.lists.range 10 (10 + count - 1);
        in "options v4l2loopback devices=${toString count} video_nr=${lib.concatMapStringsSep "," toString ids} card_label=${lib.concatMapStringsSep "," (i: "VirtualCam${toString (i - 10)}") ids} exclusive_caps=1";
      in virtualCamsModprobe 5;
    })
  ];
}
