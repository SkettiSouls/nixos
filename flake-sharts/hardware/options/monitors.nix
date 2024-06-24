### Kalyx had almost exactly what I wanted for monitor configuration, so I stole it. See https://github.com/juiced-devs/kalyx. ###
{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;

  monitorSubmodule = types.submodule {
    options = {
       # Disable monitor
      disable = mkOption {
        type = types.bool;
        default = false;
      };

      displayPort = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      resolution = mkOption {
        type = types.str;
        default = "preffered"; # This can be 'maxrefreshrate', 'maxresolution', 'preffered' or a specific resolution such as '1920x1080'
      };                       # if you specify a verbatum monitor resolution you need to set a refresh rate.

      refreshRate = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      primary = mkEnableOption "Set this monitor as the default";

      position = mkOption {
        type = types.str;
        default = "automatic"; # This can be 'automatic' or '0x0' where the first 0 is the x position and the second is the y.
      };                       # TODO: add functionality for 'leftof DP-X', 'rightof DP-X', etc.

      mirror = mkOption {
        type = types.nullOr types.str; # If you set this to the name of a display it will mirror that display.
        default = null;
      };

      scale = mkOption {
        type = types.int;
        default = 1;
      };

      rotation = mkOption {
        type = types.enum [ 0 90 180 270 ];
        default = 0;
      };

      workspaces = mkOption {
        type = types.listOf types.int;
        default = [];
      };

      defaultWorkspace = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      bitdepth = mkOption {
        type = types.enum [ 8 10 ];
        default = 8;
      };

      # ID for laptop lid open/close event.
      lidSwitch = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  cfg = config.shit.hardware.monitors;
in
{
  options.shit.hardware = {
    monitors = mkOption {
      type = types.listOf monitorSubmodule;
      default = [];
    };

    defaultMonitor = mkOption { # This sets the options for all monitors plugged in but not specified.
      type = monitorSubmodule;  # It takes the same options as regular monitors but the adapter, and workspace options do nothing.
      default = {
        resolution = "preffered";
        position = "automatic";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = !((lib.findSingle (x: x.primary) false true cfg.monitors) == true);
        message = ''ERROR:
- You have two primary monitors set! please remove one.'';
      }

      {
        assertion = !((lib.findSingle (x: x.adapter == null) false true cfg.monitors) == true);
        message = ''ERROR:
- You created a monitor without an adapter set.'';
      }
    ];

    home-manager.sharedModules = let
      monitorList = cfg.monitors;
      defaultMon = cfg.defaultMonitor;
    in
    [{
      # TODO: Make these options.
      # shit.hardware.monitors = {
      #   monitors = monitorList;
      #   defaultMonitor = defaultMon;
      # };
    }];
  };
}
