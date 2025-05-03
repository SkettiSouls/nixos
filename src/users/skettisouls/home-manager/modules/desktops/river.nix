self@{ flakeRoot, lib, ... }:
{ config, lib, pkgs, ... }:
let
  inherit (self.lib) exponent;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  inherit (config)
    basalt
    nixcord
    regolith
    ;

  inherit (basalt) discord;
  inherit (nixcord) vencord vesktop;

  inherit (regolith.river.variables)
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
  defaultHeadphones = basalt.headphones.default;
  cfg = config.basalt.desktops.river;

  sleep = {
    cores = with builtins;
      toFile "polyphasia.json" (toJSON [
        {
          start = 0.0;
          duration = 1.5;
        }
        {
          start = 6.0;
          duration = 1.0;
        }
        {
          start = 11.5;
          duration = 1.5;
        }
      ]);
  };
in
{
options = {
  basalt.desktops.river.enable = mkEnableOption "RiverWM Config";

    regolith.river = {
      variables = {
        altMod = mkOption {
          type = types.str;
          default = "${modKey}+Alt";
        };
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      bin.chp
      bin.grime
      dunst
      keepassxc
      lswt
      polyphasia
      wbg
      wl-clipboard
    ];

    regolith.river = mkIf cfg.enable {
      enable = true;
      installTerminal = false;

      startup.apps = [
        "dunst &"
        "polkit &"
        "chp ${defaultHeadphones}"
        "polyphasia ${sleep.cores} --padding 2"

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
          steam = {
            # Fix missing borders
            ssd = true;

            byTitle = {
              "*Steam" = {
                float = false;
                tags = 3;
              };

              "Launching..." = {
                float = true;
              };

              "'Special Offers'" = {
                float = true;
                tags = 3;
              };
            };
          };

          # Spawn keepassxc on tag 11, but allow the "Unlock Database" popup to spawn on any tag.
          "org.keepassxc.KeePassXC".byTitle = {
            "'*[Locked] - KeePassXC'" = { tags = 11; };
            "KeePassXC" = { tags = 11; };
          };
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

        mouse = {
          normal = [
            "${modKey} BTN_MIDDLE"
          ];
        };
      };
    };
  };
}
