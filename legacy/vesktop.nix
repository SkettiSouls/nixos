{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mapAttrs'
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

  cfg = config.programs.vesktop;
  mkConfig = builtins.toJSON;
in
{
  options.programs.vesktop = {
    enable = mkEnableOption "Vesktop discord client";
    package = mkPackageOption pkgs "vesktop" {};
    settings = mkOption {
      description = ''Vencord settings.'';
      default = { };
      type = types.attrs;
      example = ''
        programs.vesktop.settings = {
          notifyAboutUpdates = true;
          autoUpdate = true;
          autoUpdateNotification = true;
          useQuickCss = false;
          themeLinks = [
            "https://mytheme.url/path/to/theme.css"
          ];
          enabledThemes = [
            "mytheme.css"
          ];
          enableReactDevtool = false;
          frameless = false;
          transparent = false;
        };
      '';
    };
    state = mkOption {
      description = ''Vesktop settings.'';
      default = { };
      type = types.attrs;
      example = ''
        programs.vesktop.state = {
          discordBranch = "stable";
          firstLaunch = false;
          arRPC = "on";
          splashColor = "rgb(138, 148, 168)";
          splashBackground = "rgb(22, 24, 29)";
          minimizeToTray = false;
          splashTheming = true;
          customTitleBar = false;
        };
      '';
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
      example = ''
        programs.vesktop.plugins = {
          GifPaste.enable = true;
          iLoveSpam.enable = false;
          ImageZoom = {
            enable = true;
            settings = {
              saveZoomValues = false;
              invertScroll = false;
              nearestNeighbour = false;
              square = false;
              zoom = 2;
              size = 100.00;
              zoomSpeed = 0.5;
            };
          };
        };
      '';
    };
    enabledPlugins = mkOption {
      description = ''List of plugins to enable.''; # Useful for plugins that don't have settings.
      default = [ ];
      type = with types; listOf str;
      example = ''
        programs.vesktop.enabledPlugins = [
          AlwaysAnimate
          GifPaste
          ImageZoom
        ];
      '';
    };
    notifications = mkOption {
      description = ''Vencord notification settings.'';
      default = { };
      type = with types; attrsOf (either str int);
      example = ''
        timeout = 5000;
        position = "bottom-right";
        useNative = "not-focused";
        logLimit = 50;
      '';
    };
    cloud = mkOption {
      description = ''Vencord cloud integration settings.'';
      default = { };
      type = types.attrs;
      example = ''
        authenticated = true;
        url = "https://api.vencord.dev";
        settingsSync = true;
      '';
    };
    themes = mkOption {
      description = ''Local css themes for vencord.'';
      default = { };
      type = with types; attrsOf (submodule {
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
    # Requires Vesktop v1.5.0 or newer, as vesktop was rebranded from vencorddesktop, changing file structures and directory names.
    home.packages = [ cfg.package ];
    # TODO: Assert if Vesktop version < v1.5.0

    home.file = mkMerge ([
      (mapAttrs'
        (name: themes: nameValuePair
          ".config/vesktop/themes/${name}.css"
          {
            text = mkIf (themes.text != "") themes.text;
            source = mkIf (themes.source != "") themes.source;
          }
        )
      cfg.themes)

      {
        # Vesktop can't work without write access to `state.json`, and will error on first launch if settings.json is read-only.
        # For now, you must hit the 'submit' button, and then close and reopen vesktop.

        # TODO: Find a way around 'Welcome to Vesktop' menu.
        # TODO: (Optional) Find a way to disable vesktop writing window bounds to state.json.

        ".config/vesktop/settings.json".text = mkConfig cfg.state;
        ".config/vesktop/settings/settings.json".text = mkConfig (recursiveUpdate
          cfg.settings
          {
            notifications = cfg.notifications;
            cloud = cfg.cloud;
            plugins =
              # Convert enabled plugins list to "plugin":{ "enabled" = true }
              (listToAttrs (map
                (plugins: nameValuePair
                  plugins
                  { enabled = true; }
                )
              cfg.enabledPlugins)) //
              # Map 'settings' attrset
              (mapAttrs'
                (name: plugin: nameValuePair
                  name
                  ({ enabled = plugin.enable; } // plugin.settings)
                )
              cfg.plugins);
          }
        );
      }
    ]);
  };
}
