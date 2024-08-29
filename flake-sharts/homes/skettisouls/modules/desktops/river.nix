{ self, config, lib, pkgs, ... }:
let
  inherit (self.lib) exponent;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  inherit (config.shit)
    browsers
    discord
    kitty
    river
    ;

  inherit (river.variables)
    appMod
    discordClient
    modKey
    specialMod
    terminal
    ;

  inherit (config.nixcord) vesktop;
  inherit (config.peripherals.bluetooth) defaultHeadphones;


  mkTag = tag: toString (exponent 2 (tag - 1));

  cfg = config.sketti.desktops.river;
in
{
  options.sketti.desktops.river = {
    enable = mkEnableOption "RiverWM Config";
  };

  options.shit.river = {
    variables = {
      discordClient = mkOption {
        type = types.str;
        default = "discord";
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

        config.shit.browsers.default
        (mkIf discord.enable "${discordClient}")
        "steam"
        "sonixd"
      ];

      rules = {
        byId = {
          ${discordClient} = { tags = 2; };
          Sonixd = { tags = 10; };
          steam = { tags = 3; };
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
            "${appMod} B" = "spawn ${browsers.default}";
            "${appMod} D" = mkIf discord.enable "spawn ${discordClient}";
            "${appMod} M" = "spawn sonixd";
            "${appMod} S" = "spawn steam";
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
        # TODO: Move to discord module for universal default
        discordClient = mkIf vesktop.enable "vesktop";
        terminal = mkIf kitty.enable "kitty";
        specialMod = "${modKey}+Alt";
      };
    };
  };
}
