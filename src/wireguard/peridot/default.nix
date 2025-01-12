{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  peers = import ./peers.nix;
  peersList = lib.attrValues (lib.mapAttrs (peer: config: config // { name = peer; }) peers);

  cfg = config.wireguard.peridot;
in
{
  imports = [ ./firewall.nix ];

  options.wireguard.peridot = {
    enable = mkEnableOption "Enable peridot network";
    peer = mkOption {
      type = types.enum (lib.attrNames peers);
      default = config.networking.hostName;
    };
  };

  config = mkIf cfg.enable {
    networking = {
      wireguard = {
        enable = true;
        interfaces.peridot = {
          ips = peers.${cfg.peer}.allowedIPs;
          listenPort = 51820;
          privateKeyFile = "/var/lib/wireguard/key";
          peers = peersList;
        };
      };
    };
  };
}
