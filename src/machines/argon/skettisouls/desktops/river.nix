self@{ flakeRoot, lib, ... }:
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (self.lib) exponent;

  inherit (config.basalt) discord;
  inherit (config.nixcord) vencord vesktop;
  inherit (config.flake.wrappers.${pkgs.system}.skettisouls) polyphasia;

  inherit (config.regolith.river.variables)
    altMod
    appMod
    modKey
    specialMod
    terminal
    ;

  mkTag = tag: toString (exponent 2 (tag - 1));

  # Discord's canary branch has a different binary name than package name, and uses "discord" as the app-id
  discordClient = if lib.getName vencord.finalPackage == "discord-canary" then "discordcanary" else lib.getName vencord.finalPackage;
  discordAppId = if vesktop.enable then "vesktop" else "discord";

  defaultBrowser = config.xdg.browser.default;
  defaultHeadphones = config.basalt.headphones.default;
  cfg = config.basalt.desktops.river;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bin.chp
      bin.grime
      dunst
      polyphasia
      wbg
    ];

    regolith.river = mkIf cfg.enable {
      enable = true;
      package = pkgs.unstable.river;
      installTerminal = false;

      startup.apps = [
        "dunst &"
        "chp ${defaultHeadphones}"
        "polyphasia"

        defaultBrowser
        (mkIf discord.enable "${discordClient}")
        "steam"
        "feishin"
        "keepassxc"
        "wbg ${config.basalt.wallpapers.suncat}"
      ];

      rules = {
        byId = {
          ${discordAppId} = mkIf discord.enable { tags = 2; };
          feishin = { tags = 10; };
          firefox = { ssd = true; };
          Sonixd = { tags = 10; };
        };
      };

      bind = {
        keys = {
          normal = {
            # Screenshots
            "None Print" = "spawn 'grime copy screen'";
            "Shift Print" = "spawn 'grime copy area'";
            "${modKey} Print" = "spawn 'grime copysave screen'";
            "${appMod} Print" = "spawn 'grime copysave area'";

            # System binds
            "${modKey} C" = "spawn '${terminal} -e nvim ${flakeRoot}/src'";
            "${altMod} E" = "exit"; # Alt mod to prevent accidentally killing river
            "${modKey} S" = "toggle-float";

            # Connect/disconnect headphones
            "${modKey} B" = "spawn 'chp ${defaultHeadphones}'";
            "${altMod} B" = "spawn 'bluetoothctl disconnect ${defaultHeadphones}'";

            # Open Apps
            "${appMod} B" = "spawn ${defaultBrowser}";
            "${appMod} D" = mkIf discord.enable "spawn ${discordClient}";
            "${appMod} S" = "spawn steam";

            # Music
            "${modKey} M" = "set-focused-tags ${mkTag 10}";
            "${appMod} M" = "spawn feishin";
            "${altMod} M" = "set-view-tags ${mkTag 10}";

            # Keepassxc
            "${modKey} P" = "set-focused-tags ${mkTag 11}";
            "${appMod} P" = "spawn keepassxc";
            "${altMod} P" = "set-view-tags ${mkTag 11}";
          };
        };
      };

      unbind = {
        keys.normal = [
          "${appMod} E"
          "${modKey} Space"
        ];
      };
    };
  };
}
