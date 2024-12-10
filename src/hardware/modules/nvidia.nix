# Most, if not all, of the nouveau stuff is stolen from kalyx.
{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
  ;

  cfg = config.regolith.hardware.nvidia;
  proprietary = lib.or (cfg.driver == "proprietary") (cfg.driver == "open");

  driverPkg = config.boot.kernelPackages.nvidiaPackages.beta;
in
{
  # TODO: Cuda support
  options.regolith.hardware.nvidia = {
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
      graphics = {
        enable = true;
        enable32Bit = true;

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
        open = cfg.driver == "open";
      };
    };

    services.xserver.videoDrivers = [
      (mkIf proprietary "nvidia")
    ];

    home-manager.sharedModules = mkIf proprietary [{
      wayland.windowManager.hyprland.settings = {
        "env" = [
          "LIBVA_DRIVER_NAME,nvidia"
          "XDG_SESSION_TYPE,wayland"
          "LIBVA_DRIVER_NAME,nvidia-drm"
          "__GLX_VENDOR_LIBRARY,nvidia"
        ];

        cursor = {
          no_hardware_cursors = true;
        };
      };
    }];
  };
}
