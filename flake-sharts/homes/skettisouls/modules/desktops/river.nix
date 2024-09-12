{ self, config, lib, pkgs, ... }:
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
        discordClient = mkOption {
          type = types.str;
          default = lib.getName config.nixcord.vencord.package;
        };
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      bin.chp
      dunst
      grim
      slurp
      wl-clipboard
      sonixd
    ];

    shit.river = mkIf cfg.enable {
      enable = true;
      installTerminal = false;

      startup.apps = [
        "dunst &"
        "polkit &"
        "connect-headphones ${defaultHeadphones}"

        defaultBrowser
        (mkIf discord.enable "${discordClient}")
        (mkIf roles.gaming.enable "steam")
        "sonixd"
      ];

      rules = {
        byId = {
          ${discordClient} = mkIf discord.enable { tags = 2; };
          Sonixd = { tags = 10; };
          steam = mkIf roles.gaming.enable { tags = 3; };
        };
      };

      bind = {
        keys = {
          normal = {
            # Screenshots
            "None Print" = "spawn 'grim - | wl-copy'";
            "Shift Print" = ''spawn 'grim -g "$(slurp)" - | wl-copy' '';

            # System binds
            "${modKey} C" = "spawn '${terminal} -e nvim /etc/nixos/'";
            "${specialMod} E" = "exit";
            "${modKey} M" = "set-focused-tags ${mkTag 10}";

            # Connect/disconnect headphones
            "${modKey} B" = "spawn 'connect-headphones ${defaultHeadphones}'";
            "${specialMod} B" = "spawn 'bluetoothctl disconnect ${defaultHeadphones}'";

            # Open Apps
            "${appMod} B" = "spawn ${defaultBrowser}";
            "${appMod} D" = mkIf discord.enable "spawn ${discordClient}";
            "${appMod} M" = "spawn sonixd";
            "${appMod} S" = mkIf roles.gaming.enable "spawn steam";
          };
        };
      };

      unbind = {
        keys.normal = [
          "${appMod} E"
        ];

        mouse = {
          normal = [
            "${modKey} BTN_MIDDLE"
          ];
        };
      };

      variables = {
        specialMod = "${modKey}+Alt";
      };
    };
  };
}
