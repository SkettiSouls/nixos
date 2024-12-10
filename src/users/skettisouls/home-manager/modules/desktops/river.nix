{ self, config, lib, pkgs, flakeRoot, ... }:
let
  inherit (self.lib) exponent;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  inherit (config)
    shit
    roles
    peripherals
    ;

  inherit (shit)
    discord
    river
    ;

  inherit (river.variables)
    altMod
    appMod
    discordClient
    modKey
    specialMod
    terminal
    ;

  inherit (peripherals.bluetooth) defaultHeadphones;

  mkTag = tag: toString (exponent 2 (tag - 1));

  defaultBrowser = config.xdg.browser.default;
  cfg = config.shit.desktops.river;
in
{
  options.shit = {
    desktops.river.enable = mkEnableOption "RiverWM Config";

    river = {
      variables = {
        altMod = mkOption {
          type = types.str;
          default = "${modKey}+Alt";
        };

        discordClient = mkOption {
          type = types.str;
          default = lib.getName config.nixcord.vencord.finalPackage;
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
      wbg
      wl-clipboard
    ];

    shit.river = mkIf cfg.enable {
      enable = true;
      installTerminal = false;

      startup.apps = [
        "dunst &"
        "polkit &"
        "chp ${defaultHeadphones}"

        defaultBrowser
        (mkIf discord.enable "${discordClient}")
        (mkIf roles.gaming.enable "steam")
        "feishin"
        "keepassxc"
        "wbg ${config.shit.wallpapers.suncat}"
      ];

      rules = {
        byId = {
          ${discordClient} = mkIf discord.enable { tags = 2; };
          feishin = { tags = 10; };
          Sonixd = { tags = 10; };
          steam = {
            byTitle = mkIf roles.gaming.enable {
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

            # Fix missing borders
            ssd = true;
          };

          # Spawn keepassxc on tag 11, but allow the "Unlock Database" popup to spawn on any tag.
          "org.keepassxc.KeePassXC".byTitle = {
            "'*[Locked] - KeePassXC'" = {
              tags = 11;
            };
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
            "${appMod} S" = mkIf roles.gaming.enable "spawn steam";

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
