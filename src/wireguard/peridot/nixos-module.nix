{ self, config, lib, ... }:
let
  inherit (lib)
    attrNames
    attrValues
    flatten
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    removePrefix
    types
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
    ;

  net = config.networking.wireguard.networks;
  localDNS = if caddy.enable then map (url: removePrefix "http://" url) (attrNames caddy.virtualHosts)
    else if nginx.enable then attrNames nginx.virtualHosts else [];
  git.port = forgejo.settings.server.HTTP_PORT;
  minecraft.ports = attrValues
    (mapAttrs
      (_: instance: mkIf instance.enable instance.serverConfig.server-port)
    nix-mc.instances);

  cfg = config.wireguard.peridot;
in
{
  options.wireguard.peridot = {
    enable = mkEnableOption "Peridot network";

    # TODO: Make work lol
    local = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to use the lan access point (192.168.1.17)
      '';
    };
  };

  config.networking = mkIf cfg.enable {
    hosts."172.16.0.1" = [ "fluorine.lan" ] ++ localDNS;

    firewall.interfaces = mkIf (config.networking.hostName == "fluorine") {
      eno1.allowedUDPPorts = [ net.peridot.self.listenPort ];
      peridot.allowedTCPPorts = flatten [
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
