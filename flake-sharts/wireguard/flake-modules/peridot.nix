{ config, ... }:
let
  port = toString config.wireguard.networks.peridot.listenPort;
in
{
  wireguard = {
    networks.peridot = {
      listenPort = 51820;
      peers.by-name = {
        argon = {
          publicKey = "bk06qmrZbETsEsMMLkk2JcvKFzMCT10tcUs590YdEGE=";
          ipv4 = [ "172.16.0.2/32" ];
          privateKeyFile = "/var/lib/wireguard/key";
        };

        fluorine = {
          publicKey = "FU6dCHJ5Z33MF1MX4IavAxrh2jgKpBhdRocWB+RcPgg=";
          ipv4 = [ "172.16.0.1/32" ];
          privateKeyFile = "/var/lib/wireguard/key";
          selfEndpoint = "192.168.1.17:${port}";
        };
      };
    };
  };
}
