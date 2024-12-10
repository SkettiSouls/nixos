{ inputs, config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.basalt.discord;
in
{
  imports = [ inputs.nixcord.homeModules.vencord ];

  options.basalt = {
    discord.enable = mkEnableOption "Discord clients configuration";

  };

  config.nixcord = mkIf cfg.enable {
    vesktop = {
      enable = true;
      state = {
        discordBranch = "stable";
        splashColor = "rgb(138, 148, 168)";
        splashBackground = "rgb(22, 24, 29)";
        minimizeToTray = false;
        splashTheming = true;
      };
    };

    vencord = import ./plugins.nix // {
      settings = {
        autoUpdate = true;
        notifyAboutUpdates = false;

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
