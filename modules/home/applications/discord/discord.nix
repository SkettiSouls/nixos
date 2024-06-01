{ config, lib, pkgs, ... }:

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
    home.packages = with pkgs; [
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
        withTTS = true;
      })
    ];

    programs.vesktop = {
      enable = true;
      package = pkgs.vesktop-unstable;

      state = {
        discordBranch = "stable";
        firstLaunch = false;
        arRPC = "off";
        splashColor = "rgb(138, 148, 168)";
        splashBackground = "rgb(22, 24, 29)";
        minimizeToTray = false;
        splashTheming = true;
        customTitleBar = false;
      };

      settings = {
        notifyAboutUpdates = true;
        autoUpdate = true;
        autoUpdateNotification = true;
        useQuickCss = false;
        themeLinks = [ ];
        enabledThemes = [ "midnight.css" ];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
      };

      cloud = {
        authenticated = true;
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
        midnight.css = ./midnight.css;
      };
    };
  };
}
