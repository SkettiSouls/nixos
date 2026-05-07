{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;

  cfg = config.services.deemix-server;
  deemix-server = pkgs.callPackage ./package.nix {};
in
{
  options.services.deemix-server = {
    enable = mkEnableOption "Deemix Server";

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
    };

    openPort = mkOption {
      type = types.bool;
      default = false;
    };

    port = mkOption {
      type = types.port;
      default = 6595;
    };
  };

  config = mkIf cfg.enable {
    users.groups.deemix = { };
    users.users.deemix = {
      description = "Deemix Server User";
      home = "/var/lib/deemix";
      createHome = true;
      isSystemUser = true;
      group = "deemix";
    };

    systemd.services.deemix-server = {
      description = "Deemix Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''
          ${deemix-server}/bin/deemix-server --port ${toString cfg.port} --host ${toString cfg.listenAddress}
        '';
        PrivateTmp = false;
        Restart = "always";
        User = "deemix";
        WorkingDirectory = "/var/lib/deemix";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openPort [ cfg.port ];
  };
}
