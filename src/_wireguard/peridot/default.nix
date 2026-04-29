{ config, lib, ... }:
let
  inherit (lib)
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
    peer = mkOption {
      type = types.enum (lib.attrNames peers);
      default = config.networking.hostName;
    };
  };

  config.networking = {
    wireguard = {
      enable = true;
      interfaces.peridot = {
        ips = lib.mkDefault peers.${cfg.peer}.allowedIPs;
        listenPort = 51820;
        privateKeyFile = "/var/lib/wireguard/key";
        peers = peersList;
      };
    };
  };
}
