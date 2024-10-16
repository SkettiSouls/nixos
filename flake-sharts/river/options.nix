{ config, lib, pkgs, options, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    range
    types
    ;

  bindSubmodule = types.submodule {
    options = (lib.genAttrs cfg.modes (n: mkOption {
      type = types.attrs;
      default = {};
    }));
  };

  unbindSubmodule = types.submodule {
    options = (lib.genAttrs cfg.modes (n: mkOption {
      type = with types; listOf str;
      default = [];
    }));
  };

  keybindOptions = type: {
    keys = mkOption {
      type = type;
      default = {};
    };

    mouse = mkOption {
      type = type;
      default = {};
    };

    switch = mkOption {
      type = type;
      default = {};
    };
  };

  mkNullableBool = str: mkOption {
    type = with types; nullOr (either bool types.str);
    default = null;
    description = str;
  };

  ruleOptions = {
    csd = mkNullableBool "";
    ssd = mkNullableBool "";
    float = mkNullableBool "View floating state on spawn";
    fullscreen = mkNullableBool "View fullscreen state on spawn";

    dimensions = mkOption {
      type = with types; nullOr (either str int);
      default = null;
    };

    output = mkOption {
      type = with types; nullOr int;
      default = null;
    };

    position = mkOption {
      type = with types; nullOr (either str int);
      default = null;
    };

    tags = mkOption {
      type = with types; nullOr int;
      default = null;
    };
  };

  cfg = config.shit.river;
in
{
  options.shit.river = {
    enable = mkEnableOption "River WM";
    bind = keybindOptions bindSubmodule;
    unbind = keybindOptions unbindSubmodule;

    # Passthrough
    package = options.wayland.windowManager.river.package;
    settings = options.wayland.windowManager.river.settings;
    extraConfig = options.wayland.windowManager.river.extraConfig;

    installTerminal = mkOption {
      type = types.bool;
      default = true;
    };

    layout = {
      config = mkOption {
        type = with types; nullOr (either str lines);
        default = null;
      };

      generator = mkOption {
        type = with types; oneOf [ (enum [ "rivertile" ]) path package ];
        default = "rivertile";
      };
    };

    modes = mkOption {
      type = with types; listOf str;
      default = [ "locked" "normal" ] ++ cfg.extraModes ++ [ (lib.mkIf cfg.passthrough.enable "passthrough") ];
    };

    extraModes = mkOption {
      type = with types; listOf str;
      default = [];
      description = ''
        Additional modes to be set after `locked` and `normal`.
      '';
    };

    passthrough = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable passthrough mode. This is helpful for testing in nested wayland sessions.";
      };

      keybind = mkOption {
        type = types.str;
        default = "F11";
        description = ''
          Keybind for entering and exiting passthrough mode.
          Will be prepended with your mod key (${cfg.variables.modKey})
        '';
      };
    };

    rules = {
      byId = mkOption {
        type = with types; nullOr (attrsOf (submodule {
          options = {
            byTitle = mkOption {
              type = with types; nullOr (attrsOf (submodule { options = ruleOptions; }));
              default = null;
            };
          } // ruleOptions;
        }));
        default = null;
      };

      byTitle = mkOption {
        type = with types; nullOr (attrsOf (submodule {
          options = {
            byId = mkOption {
              type = with types; nullOr (attrsOf (submodule { options = ruleOptions; }));
              default = null;
            };
          } // ruleOptions;
        }));
        default = null;
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
      };
    };

    startup.apps = mkOption {
      type = with types; listOf str;
      default = [];
    };

    tags = mkOption {
      type = with types; listOf int;
      default = (range 1 9);
      description = ''
        Set the tags to bind by default.
        It is highly recommended to leave this option as is (binds keys 1-9).
      '';
    };

    variables = {
      modKey = mkOption {
        type = types.str;
        default = "Super";
      };

      appMod = mkOption {
        type = types.str;
        default = "Super+Shift";
      };

      specialMod = mkOption {
        type = types.str;
        default = "Super+Control";
      };

      terminal = mkOption {
        type = types.str;
        default = "foot";
      };
    };
  };
}
