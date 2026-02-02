{ self, config, lib, ... }:
let
  inherit (lib)
    attrNames
    attrValues
    flatten
    mapAttrs
    mkIf
    removePrefix
    ;

  inherit (self.nixosConfigurations.fluorine.config.services)
    caddy
    deemix-server
    forgejo
    gonic
    nginx
    nix-mc
    steam-dedicated
    ;

  inherit (config.networking.wireguard.interfaces) peridot;

  git.port = forgejo.settings.server.HTTP_PORT;

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
in
{
  config.networking = {
    hosts."192.168.10.1" = [ "fluorine.lan" ] ++ localDNS;

    firewall.interfaces = mkIf (config.networking.hostName == "fluorine") {
      eno1.allowedUDPPorts = [ peridot.listenPort ];
      peridot = {
        allowedUDPPorts = steam.ports ++ minecraft.ports ++ [ 42420 ];
        allowedTCPPorts = flatten [
          20
          80
          443
          27020 # Ark Rcon
          42420 # Vintage Story
          deemix-server.port
          git.port
          gonic.port
          minecraft.ports
          steam.ports
          peridot.listenPort
        ];
      };
    };
  };
}
