# Most, if not all, of the nouveau stuff is stolen from kalyx.
{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
  ;

  cfg = config.shit.hardware.nvidia;
  proprietary = lib.or (cfg.driver == "proprietary") (cfg.driver == "open");

  driverPkg = config.boot.kernelPackages.nvidiaPackages.beta;
in
{
  # TODO: Cuda support
  options.shit.hardware.nvidia = {
    enable = mkEnableOption "NoVideo";
    driver = mkOption {
      type = types.enum [ "nouveau" "proprietary" "open" ];
      default = "proprietary";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; mkIf proprietary [
      egl-wayland
      libva-utils
      nvidia-vaapi-driver
    ];

    boot = {
      initrd.kernelModules = [
        "vfio"
        "vfio_pci"
      ] ++ (if proprietary then [
        "nvidia"
        "nvidia_modeset"
        "nvidia_drm"
      ] else [
        "nouveau"
      ]);

      kernelParams = [] ++ (if proprietary then [
        "video=vesafb:off,efifb:off"
      ] else []);

      extraModprobeConfig = if proprietary then ''
        options nvidia NVreg_PreserveVideoMemoryAllocations=1
      '' else '''';
    };

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        setLdLibraryPath = true;

        extraPackages = with pkgs; [] ++ (if proprietary then [
          vaapiVdpau
          libvdpau-va-gl
        ] else [
          mesa
          libGL
        ]);
      };

      nvidia = {
        package = mkIf proprietary driverPkg;
        modesetting.enable = true;
        open = (cfg.driver == "open");
      };
    };

    services.xserver.videoDrivers = [
      (mkIf proprietary "nvidia")
    ];
  };
}
