{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.discord;
in
{
  imports = [
    inputs.nixcord.nixosModules.vencord
    ./plugins.nix
  ];

  options.shit.discord = {
    enable = mkEnableOption "Discord clients configuration";
  };

  config.nixcord = mkIf cfg.enable {
    vesktop = {
      enable = true;
      package = pkgs.vesktop-unstable;
      state = {
        discordBranch = "stable";
        arRPC = false;
        splashColor = "rgb(138, 148, 168)";
        splashBackground = "rgb(22, 24, 29)";
        minimizeToTray = false;
        splashTheming = true;
        customTitleBar = false;
      };
    };

    vencord = {
      enable = true;

      settings = {
        notifyAboutUpdates = true;
        # autoUpdate = false;
        # autoUpdateNotification = false;
        themeLinks = [ ];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;

        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 75;
        };
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
