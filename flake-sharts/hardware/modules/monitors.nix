{ self, config, lib, ... }:
let
  inherit (self.lib)
    listToAttrs'
    ;

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

  cfg = config.shit.hardware;
  mon = listToAttrs' cfg.monitors;
in
{
  options.shit.hardware = {
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
        assertion = (builtins.any (bool: bool == true) (if mon.refreshRate == null then map (res: res == mon.resolution) [ "maxresolution" "maxrefreshrate" "preffered" ] else [true]));
        message = ''
          Manual screen resolution requires setting a refresh rate.
        '';
      }
    ];

    home-manager.sharedModules = let
      monitorList = cfg.monitors;
      defaultMon = cfg.defaultMonitor;
    in
    [{
      shit.hardware.monitors = {
        monitors = monitorList;
        defaultMonitor = defaultMon;
      };
    }];
  };
}
