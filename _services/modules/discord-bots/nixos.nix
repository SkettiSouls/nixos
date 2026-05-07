{ config, lib, ... }:
let
  inherit (lib)
    filterAttrs
    mapAttrs'
    mkEnableOption
    mkOption
    nameValuePair
    types
    ;

  cfg = config.services.discord;
in
{
  options.services.discord = {
    bots = mkOption {
      type = with types; attrsOf (submodule {
        options = {
          enable = mkEnableOption "Enable bot";
          package = mkOption { type = types.package; };
          startCMD = mkOption {
            type = with types; nullOr (either str lines);
            default = null;
            description = "Command to use for systemd StartExec";
          };
        };
      });

      default = {};
    };
  };

  config = let
    enabledBots = filterAttrs (_: x: x.enable) cfg.bots;

    perEnabledBot = func:
      mapAttrs' (b: c: nameValuePair "dc-${b}" (func b c)) enabledBots;
  in {
    users.groups.bots = {};
    users.users.bots = {
      createHome = true;
      group = "bots";
      home = "/var/lib/bots";
      isSystemUser = true;
    };

    systemd.services = perEnabledBot (name: bcfg: {
      description = "Discord bot - ${name}";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = if bcfg.startCMD != null then bcfg.startCMD else "${bcfg.package}/bin/${name}";
        WorkingDirectory = "/var/lib/bots/${name}";
        Restart = "always";
        User = "bots";
        StateDirectory = "${name}";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    });
  };
}
