{ config, pkgs, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;

  cfg = config.services.minecraft.terraFirmaGreg;
in
{
  options.services.minecraft.terraFirmaGreg = {
    enable = mkEnableOption "TerraFirmaGreg Server";
    allowCracked = mkEnableOption "Allow users to join from cracked clients";
    noMobs = mkEnableOption "Disable mobs for realism";

    allowedIdleTime = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Time in minutes before a player is kicked for idling.
        Set to 0 to disable idle timeout.
      '';
    };

    args = mkOption {
      type = types.str;
      default = "-Xmx6024M -Xms1024M";
    };

    motd = mkOption {
      type = types.str;
      default = "";
    };

    port = mkOption {
      type = types.int;
      default = 25565;
    };

    query = {
      enable = mkEnableOption "GameSpy4 protocol server listener";
      port = mkOption {
        type = types.int;
        default = cfg.port;
      };
    };

    seed = mkOption {
      type = types.str;
      default = "";
    };

    whitelist = mkOption {
      type = let
        minecraftUUID = types.strMatching
          "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" // {
            description = "Minecraft UUID";
          };
        in types.attrsOf minecraftUUID;
      default = {};

      example = lib.literalExpression ''
        {
          username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
          username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
        };
      '';
    };

    worldName = mkOption {
      type = types.str;
      default = "world";
    };
  };

  config = mkIf cfg.enable {
    services.minecraft-server = {
      declarative = true;
      enable = true;
      eula = true;
      jvmOpts = cfg.args;
      package = pkgs.self.terraFirmaGreg;
      whitelist = cfg.whitelist;

      serverProperties = {
        allow-flight = true;
        allow-nether = false;
        broadcast-console-to-ops = true;
        broadcast-rcon-to-ops = true;
        difficulty = if cfg.noMobs then 0 else 3;
        enable-command-block = false;
        enable-query = cfg.query.enable;
        enable-jmx-monitoring = false;
        enable-rcon = false;
        enable-status = true;
        enforce-secure-profile = false;
        enforce-whitelist = false;
        entity-broacast-range-percentage = 100;
        force-gamemode = false;
        function-permission-level = 2;
        gamemode = 0;
        generate-structures = true;
        hardcore = false;
        hide-online-players = false;
        initial-enabled-packs = "vanilla";
        level-name = cfg.worldName;
        level-seed = mkIf (cfg.seed != "") cfg.seed;
        max-chained-neighbor-updates = 1000000;
        max-players = 10;
        max-tick-time = 60000;
        max-world-size = 29999984;
        motd = lib.concatStringsSep " " [ "[TerraFirmaGreg 1.20.1]" cfg.motd ];
        network-compression-threshold = 256;
        online-mode = if cfg.allowCracked then false else true;
        op-permission-level = 4;
        player-idle-timeout = cfg.allowedIdleTime;
        prevent-proxy-connections = false;
        pvp = true;
        "query.port" = cfg.query.port;
        rate-limit = 0;
        # TODO: Resource Pack stuff
        server-port = cfg.port;
        simulation-distance = 8;
        spawn-animals = true;
        spawn-monsters = !(cfg.noMobs);
        spawn-npcs = true;
        spawn-protection = 16;
        sync-chunk-writes = true;
        use-native-transport = true;
        view-distance = 8;
        white-list = mkIf (config.services.minecraft-server.whitelist != {}) true;
      };
    };
  };
}
