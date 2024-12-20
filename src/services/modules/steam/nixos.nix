{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.steam-dedicated;
in
{
  options.services.steam-dedicated = mkOption {
    type = with types; attrsOf (submodule ({ name, ... }: {
      options = {
        enable = mkEnableOption "Dedicated ${name} server";
        port = mkOption {
          type = int;
          default = 2456;
        };

        appId = mkOption {
          type = int;
          description = "Steam App Id";
        };

        startCmd = mkOption {
          type = lines;
          default = "";
          description = "Systemd service ExecStart commands";
        };

        serviceConfig = mkOption {
          type = attrs;
          default = {};
          description = "Convenience option for `systemd.services.${name}.serviceConfig`";
        };
      };
    }));
    default = {};
  };

  config = {
    users.groups.steam = {};
    users.users.steam = {
      description = "Steam Dedicated Servers User";
      home = "/var/lib/steam";
      createHome = true;
      isSystemUser = true;
      group = "steam";
    };

    systemd.services = lib.mapAttrs' (name: _:
      {
        inherit name;
        value = mkIf cfg.${name}.enable {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            StateDirectory = "steam/${name}";
            User = "steam";
            WorkingDirectory = "/var/lib/steam/${name}";

            ExecStartPre = ''
              ${pkgs.steamcmd}/bin/steamcmd \
              +force_install_dir $STATE_DIRECTORY \
              +login anonymous \
              +app_update ${toString cfg.${name}.appId} \
              +quit
            '';

            ExecStart = cfg.${name}.startCmd;
          };
        } // cfg.${name}.serviceConfig;
      }
    ) cfg;
  };
}
