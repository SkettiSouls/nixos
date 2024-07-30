{ config, ... }:
let
  net = config.networking.wireguard.networks;
in
{
  # TODO: Switch to using sops/agenix
  networking = {
    hosts = {
      "172.16.0.1" = [
        "fluorine.lan"
        "airsonic.fluorine.lan"
        "deemix.fluorine.lan"
      ];
    };

    firewall.interfaces = {
      eno1.allowedUDPPorts = [ net.peridot.self.listenPort ];
      peridot.allowedTCPPorts = [ 20 80 443 ];
    };

    wireguard = {
      interfaces.peridot = {
        generatePrivateKeyFile = true;
        privateKeyFile = "/var/lib/wireguard/key";
      };

      networks = {
        peridot.autoConfig = {
          interface = true;
          peers = true;
        };
      };
    };
  };
}
