{ inputs, config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.discord;
in
{
  options.shit.discord = {
    enable = mkEnableOption "Discord clients configuration";
  };

  config = mkIf cfg.enable {
    programs.vencord = {
      enable = true;
      vesktop = {
        enable = true;
        package = pkgs.vesktop-unstable;
        state = {
          discordBranch = "stable";
          # firstLaunch = false; # Causes vesktop to hang indefinitely on first launch.
          arRPC = "off";
          splashColor = "rgb(138, 148, 168)";
          splashBackground = "rgb(22, 24, 29)";
          minimizeToTray = false;
          splashTheming = true;
          customTitleBar = false;
        };
      };

      settings = {
        notifyAboutUpdates = true;
        autoUpdate = true;
        autoUpdateNotification = true;
        useQuickCss = false;
        themeLinks = [ ];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
      };

      cloud = {
        authenticated = false;
        url = "https://api.vencord.dev";
        settingsSync = false;
      };

      notifications = {
        timeout = 5000;
        position = "bottom-right";
        useNative = "not-focused";
        logLimit = 75;
      };

      themes = {
        midnight = {
          enable = true;
          source = "${inputs.midnight-discord}/midnight.css";
        };
      };
    };
  };
}
