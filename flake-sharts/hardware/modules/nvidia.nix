{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
  ;

  cfg = config.shit.hardware.nvidia;
in
{
  options.shit.hardware.nvidia = {
    enable = mkEnableOption "NoVideo";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      egl-wayland
      nvidia-vaapi-driver
    ];

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        nvidiaSettings = true;
      };
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
