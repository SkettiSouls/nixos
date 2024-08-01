{ self, config, lib, ... }:
let
  inherit (lib)
    attrNames
    flatten
    mkIf
    removePrefix
    ;

  inherit (self.nixosConfigurations.fluorine.config.services)
    airsonic
    caddy
    deemix-server
    invidious
    nginx
    ;

  net = config.networking.wireguard.networks;
  localDNS = if caddy.enable then map (url: removePrefix "http://" url) (attrNames caddy.virtualHosts) else if nginx.enable then attrNames nginx.virtualHosts else [];
in
{
  # TODO: Switch to using sops/agenix
  networking = {
    hosts."172.16.0.1" = [ "fluorine.lan" ] ++ localDNS;

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
