{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkPackageOption
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

  rulesEnum = (types.enum [
    "csd"
    "float"
    "fullscreen"
    "no-float"
    "no-fullscreen"
    "ssd"
  ]);

  rulesSubmodule = {
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

    package = mkPackageOption pkgs "river" {
      nullable = true;
      extraDescription = ''
        Convenience passthrough for wayland.windowManagers.river.package.
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
        type = with types; nullOr (attrsOf (either rulesEnum (submodule {
          options = {
            byTitle = mkOption {
              type = with types; nullOr (attrsOf (either rulesEnum (submodule {
                options = rulesSubmodule;
              })));
              default = null;
            };
          } // rulesSubmodule;
        })));
        default = null;
      };

      byTitle = mkOption {
        type = with types; nullOr (attrsOf (either rulesEnum (submodule {
          options = {
            byId = mkOption {
              type = with types; nullOr (attrsOf (either rulesEnum (submodule {
                options = rulesSubmodule;
              })));
              default = null;
            };
          } // rulesSubmodule;
        })));
        default = null;
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
      };
    };

    settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Convenience passthrough for wayland.windowManagers.river.settings";
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
