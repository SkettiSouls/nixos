# NOTE: Most of this module was written while working on the now defunct Kalyx, with Hyprland in mind.
{ config, options, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;

  monitorSubmodule = types.submodule {
    options = {
      disable = mkEnableOption "Disable the monitor.";
      flipped = mkEnableOption "Flip the monitor horizontally."; # TODO: Warn when using (cursed).
      primary = mkEnableOption "Set this monitor as the default";

      displayPort = mkOption {
        type = types.str;
        default = "";
      };

      resolution = mkOption {
        description = ''
          Set the display resolution.

          Accepted values are "maxrefreshrate", "maxresolution",
          "preffered", or a specified pixel ratio, such as "1920x1080".
        '';
        type = types.str;
        default = "preffered";
      };

      refreshRate = mkOption {
        type = types.nullOr types.int;
        default = null;
      };


      position = mkOption {
        description = ''
          Set the monitor's position.

          Accepted values are 'automatic' or XY coordinates (i.e 0x0, 1920x1080)
        '';
        type = types.str;
        default = "automatic"; # TODO: add functionality for 'leftof DP-X', 'rightof DP-X', etc.
      };

      mirror = mkOption {
        description = ''Mirror the specified display.'';
        type = types.nullOr types.str;
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

  cfg = config.regolith.hardware;
in
{
  options.regolith.hardware = {
    monitors = mkOption {
      type = types.listOf monitorSubmodule;
      default = [{}];
    };

    defaultMonitor = mkOption {
      description = ''Set options for all monitors plugged in but not configured.'';
      type = monitorSubmodule;
      default = {
        resolution = "preffered";
        position = "automatic";
      };
    };
  };

  config = {
    assertions = [
      {
        # Check for multiple monitors being set as primary.
        assertion = (lib.findSingle (x: x.primary) false true cfg.monitors) != true;
        message = ''
          More than one primary monitor was set.
        '';
      }
      {
        # Check if refreshRate is unset, and error when using a manual resolution
        assertion = !(builtins.any (bool: bool == false) (map (mon: if mon.refreshRate == null then builtins.any (res: res == mon.resolution) [ "maxresolution" "maxrefreshrate" "preffered" ] else true) cfg.monitors));
        message = ''
          Manual screen resolution requires setting a refresh rate.
        '';
      }
    ];

    # TODO: Implementation, will work on once I have 2 monitors again.
    home-manager.sharedModules = let
      monitorList = cfg.monitors;
      defaultMon = cfg.defaultMonitor;
    in
    [{
      options.regolith.hardware = options.regolith.hardware;
      config.regolith.hardware.monitors = {
        monitors = monitorList;
        defaultMonitor = defaultMon;
      };
    }];
  };
}
