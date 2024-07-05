{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mapAttrs'
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    nameValuePair
    recursiveUpdate
    types
    ;

  inherit (builtins)
    listToAttrs
    ;

  cfg = config.programs.vencord;
  mkConfig = builtins.toJSON;
in
{
  options.programs.vencord = {
    enable = mkEnableOption "Vencord discord client mod";
    package = mkPackageOption pkgs "Discord package" { default = null; };

    vesktop = {
      enable = mkEnableOption "Vencord's discord app";
      package = mkPackageOption pkgs "vesktop" {};
      state = mkOption {
        # TODO?: Assert for `firstLaunch = false;`, breaks vesktop on first launch.
        description = ''Vesktop app settings.'';
        type = types.attrs;
        default = {};
        example = {
          discordBranch = "stable";
          splashTheming = true;
          splashColor = "rgb(138,148,168)";
          arRPC = "off";
        };
      };
    };

    settings = mkOption {
      description = ''Vencord settings.'';
      default = { };
      type = types.attrs;
      example = {
        autoUpdate = true;
        useQuickCss = false;
        enableReactDevtool = false;
        themeLinks = [
          "https://mytheme.url/path/to/theme.css"
        ];
      };
    };

    plugins = mkOption {
      description = ''Vencord plugins.'';
      default = { };
      type = with types; attrsOf (submodule {
        options.enable = mkEnableOption "Enable specified plugin.";
        options.settings = mkOption {
          type = types.attrs;
          default = { };
        };
      });

      example = {
        GifPaste.enable = true;
        ImageZoom = {
          enable = true;
          settings = {
            nearestNeighbour = false;
            zoom = 2;
            size = 100.00;
          };
        };
      };
    };

    enabledPlugins = mkOption {
      description = ''List of plugins to enable.''; # Convenient for plugins that don't have settings.
      default = [ ];
      type = with types; listOf str;
      example = [
        "AlwaysAnimate"
        "GifPaste"
      ];
    };

    notifications = mkOption {
      description = ''Vencord notification settings.'';
      default = { };
      type = with types; attrsOf (either str int);
      example = {
        timeout = 5000;
        position = "bottom-right";
        useNative = "not-focused";
        logLimit = 50;
      };
    };

    cloud = mkOption {
      description = ''Vencord cloud integration settings.'';
      default = { };
      type = types.attrs;
      example = {
        authenticated = true;
        url = "https://api.vencord.dev";
        settingsSync = true;
      };
    };

    themes = mkOption {
      description = ''Local css themes for vencord.'';
      default = { };
      type = with types; attrsOf (submodule {
        options.enable = mkEnableOption "Enable theme";
        options.source = mkOption {
          type = with types; (either str path);
          default = "";
        };

        options.text = mkOption {
          type = with types; (either str lines);
          default = "";
        };
      });

      example = {
        mytheme.text = "custom css";
        mytheme2.source = ./path/to/css;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.vencord.package = if (cfg.vesktop.enable)
      then mkDefault cfg.vesktop.package
      else mkDefault (pkgs.discord.override { withVencord = true; });

    home.packages = [ cfg.package ];

    home.file = mkMerge ([
      (mapAttrs'
        (name: attrs: nameValuePair
          ".config/Vencord/themes/${name}.css"
          {
            text = mkIf (attrs.text != "") attrs.text;
            source = mkIf (attrs.source != "") attrs.source;
          }
        )
      cfg.themes)

      {
        ".config/Vencord/settings/settings.json".text = mkConfig (recursiveUpdate
          cfg.settings
          {
            notifications = cfg.notifications;
            cloud = cfg.cloud;
            enabledThemes = lib.mapAttrsToList (name: attrs: (if attrs.enable then name + ".css" else "")) cfg.themes;
            plugins =
              # Convert enabled plugins list to "plugin":{ "enabled" = true }
              (listToAttrs (map
                (plugins: nameValuePair
                  plugins
                  { enabled = true; }
                )
              cfg.enabledPlugins)) //
              # Make cfg.plugins map to JSON correctly.
              (mapAttrs'
                (name: plugin: nameValuePair
                  name
                  ({ enabled = plugin.enable; } // plugin.settings)
                )
              cfg.plugins);
          }
        );
      }

      # Vesktop settings are taken from vencord settings to allow using vesktop and other clients
      # simultaneously. (i.e. nix running pkgs.discord for testing)
      (if cfg.vesktop.enable
        then (mapAttrs'
          (name: attrs: nameValuePair
            ".config/vesktop/themes/${name}.css"
            {
              text = mkIf (attrs.text != "") attrs.text;
              source = mkIf (attrs.source != "") attrs.source;
            }
          )
        cfg.themes)
      else {})

      (if cfg.vesktop.enable
        then {
          # Vesktop can't work without write access to `state.json`, and will error on first launch if settings.json is read-only.
          # For now, when running for the first time you must hit the 'submit' button, and then close and reopen vesktop.

          # TODO: Find a way around 'Welcome to Vesktop' menu.
          # ALTERNATIVE: Find a way to disable vesktop writing window bounds to state.json.

          ".config/vesktop/settings.json".text = mkConfig cfg.vesktop.state;
          ".config/vesktop/settings/settings.json".text = config.home.file.".config/Vencord/settings/settings.json".text;
        }
      else {})
    ]);
  };
}
