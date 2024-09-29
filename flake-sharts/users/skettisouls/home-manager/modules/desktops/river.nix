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
      dunst
      grim
      slurp
      wl-clipboard
      wbg
      keepassxc
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
        "feishin"
        "keepassxc"
        "wbg ${config.shit.wallpapers.suncat}"
      ];

      rules = {
        byId = {
          ${discordClient} = mkIf discord.enable { tags = 2; };
          feishin = { tags = 10; };
          "org.keepassxc.KeePassXC" = { tags = 11; };
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
            "${altMod} E" = "exit";

            # Connect/disconnect headphones
            "${modKey} B" = "spawn 'connect-headphones ${defaultHeadphones}'";
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
