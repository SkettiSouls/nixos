{ ... }:
{ config, options, lib, pkgs, ... }:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  inherit (config) regolith;
  inherit (regolith.river.variables) modKey;
  inherit (cfg.windowRules) steam keepassxc;

  cfg = config.basalt.desktops.river;
  mkAllDefault = set: builtins.mapAttrs (_: v: mkDefault v) set;
in
{
  options = {
    basalt.desktops.river = {
      enable = mkEnableOption "RiverWM Config";
      windowRules = {
        keepassxc = {
          enable = mkEnableOption "Preset keepassxc window rules";
          tags = mkOption {
            type = types.int;
            default = 11;
          };
        };

        steam = {
          enable = mkEnableOption "Preset steam window rules";
          tags = mkOption {
            type = types.int;
            default = 3;
          };
        };
      };
    };

    test = mkOption {
      type = types.unspecified;
      default = options.regolith.river;
    };

    regolith.river = {
      variables = {
        altMod = mkOption {
          type = types.str;
          default = "${modKey}+Alt";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lswt
      wl-clipboard
    ];

    regolith.river = mkIf cfg.enable {
      enable = true;
      package = mkDefault pkgs.unstable.river;
      installTerminal = mkDefault false;

      startup.apps = [
        "polkit &"
      ];

      rules = {
        byId = {
          firefox = mkDefault { ssd = true; };
          steam = mkIf steam.enable {
            # Fix missing borders
            ssd = mkDefault true;

            byTitle = mkAllDefault {
              "*Steam" = {
                inherit (steam) tags;
                float = false;
              };

              "Launching..." = {
                float = true;
              };

              "'Special Offers'" = {
                inherit (steam) tags;
                float = true;
              };
            };
          };

          # Spawn keepassxc on tag 11, but allow the "Unlock Database" popup to spawn on any tag.
          "org.keepassxc.KeePassXC".byTitle = mkIf keepassxc.enable {
            "'*[Locked] - KeePassXC'" = mkDefault { inherit (keepassxc) tags; };
            "KeePassXC" = mkDefault { inherit (keepassxc) tags; };
          };
        };
      };

      unbind = {
        mouse = {
          normal = mkDefault [
            "${modKey} BTN_MIDDLE"
          ];
        };
      };
    };
  };
}
