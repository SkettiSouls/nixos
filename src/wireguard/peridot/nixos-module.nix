{ self, config, lib, ... }:
let
  inherit (lib)
    attrNames
    attrValues
    flatten
    mapAttrs
    mkEnableOption
    mkIf
    removePrefix
    ;

  inherit (self.nixosConfigurations.fluorine.config.services)
    airsonic
    caddy
    deemix-server
    forgejo
    gonic
    invidious
    nginx
    nix-mc
    steam-dedicated
    ;

  git.port = forgejo.settings.server.HTTP_PORT;
  net = config.networking.wireguard.networks;

  localDNS = if caddy.enable then map (url: removePrefix "http://" url) (attrNames caddy.virtualHosts)
    else if nginx.enable then attrNames nginx.virtualHosts else [];

  minecraft.ports = attrValues
    (mapAttrs
      (_: instance: mkIf instance.enable instance.serverConfig.server-port)
    nix-mc.instances);

    steam.ports = flatten (attrValues
      (mapAttrs
        # Port 27015 is used for steam server discovery
        (_: server: lib.optionals server.enable [ server.port (server.port + 1) 27015 ])
        steam-dedicated));

  cfg = config.wireguard.peridot;
in
{
  options.wireguard.peridot.enable = mkEnableOption "Peridot network";

  config.networking = mkIf cfg.enable {
    hosts."172.16.0.1" = [ "fluorine.lan" ] ++ localDNS;

    firewall.interfaces = mkIf (config.networking.hostName == "fluorine") {
      peridot = {
        allowedUDPPorts = steam.ports;
        allowedTCPPorts = flatten [
          20
          80
          443
          4747 # Gonic
          airsonic.port
          deemix-server.port
          git.port
          gonic.port
          invidious.port
          minecraft.ports
          net.peridot.self.listenPort
        ];
      };
    };

    wireguard.networks.peridot = {
      autoConfig = {
        openFirewall = true;

        "networking.wireguard" = lib.mkForce {
          interface.enable = true;
          peers.mesh.enable = true;
        };

        "networking.hosts" = {
          enable = true;
          FQDNs.enable = true;
        };
      };
    };
  };
}
