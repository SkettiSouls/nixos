{ self, config, lib, ... }:
let
  inherit (self.nixosConfigurations.fluorine.config.services)
    airsonic
    deemix-server
    invidious
    nginx
    ;

  net = config.networking.wireguard.networks;
  localDNS = [ "fluorine.lan" ] ++ (lib.attrNames nginx.virtualHosts);
in
{
  # TODO: Switch to using sops/agenix
  networking = {
    hosts."172.16.0.1" = localDNS;

    firewall.interfaces = {
      eno1.allowedUDPPorts = [ net.peridot.self.listenPort ];
      peridot.allowedTCPPorts = [
        20
        80
        443
        airsonic.port
        deemix-server.port
        invidious.port
        net.peridot.self.listenPort
      ];
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
