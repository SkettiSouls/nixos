{ self, config, lib, ... }:
let
  inherit (lib)
    attrNames
    mkIf
    removePrefix
    ;

  inherit (self.nixosConfigurations.fluorine.config.services)
    airsonic
    caddy
    deemix-server
    forgejo
    invidious
    nginx
    nix-mc
    ;

  net = config.networking.wireguard.networks;
  localDNS = if caddy.enable then map (url: removePrefix "http://" url) (attrNames caddy.virtualHosts)
    else if nginx.enable then attrNames nginx.virtualHosts else [];
  git.port = forgejo.settings.server.HTTP_PORT;
in
{
  networking = {
    hosts."172.16.0.1" = [ "fluorine.lan" ] ++ localDNS;

    firewall.interfaces = mkIf (config.networking.hostName == "fluorine") {
      eno1.allowedUDPPorts = [ net.peridot.self.listenPort ];
      peridot.allowedTCPPorts = [
        20
        80
        443
        airsonic.port
        deemix-server.port
        git.port
        invidious.port
        nix-mc.instances.TerraFirmaGreg.serverConfig.server-port
        net.peridot.self.listenPort
      ];
    };

    wireguard = {
      interfaces.peridot = {
        generatePrivateKeyFile = true;
        privateKeyFile = "/var/lib/wireguard/key";
      };

      networks.peridot = {
        autoConfig = {
          interface = true;
          peers = true;
        };
      };
    };
  };
}
