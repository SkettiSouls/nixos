args@{ config, ... }:
let
  peers = {
    fluorine = {
      allowedIPs = [ "192.168.10.0/24" ];
      publicKey = "FU6dCHJ5Z33MF1MX4IavAxrh2jgKpBhdRocWB+RcPgg=";
      endpoint = "192.168.1.17:51820";
      persistentKeepalive = 10;
    };

    argon = {
      allowedIPs = [ "192.168.10.2/32" ];
      publicKey = "tJo5Pl9j/UhOtrj+3IWz/lj8+XBvlnqmBOY2oeTeB3s=";
    };

    xenon = {
      allowedIPs = [ "192.168.10.3/32" ];
      publicKey = "EdvMF3Os65mXq7ubtOo/XBYoJFsd+Yhga4StlrfG4z8=";

    };

    killerking = {
      allowedIPs = [ "192.168.10.183/32" ];
      publicKey = "sa51jFzlCBZlsjio+k4ZAnwvIm0aV0BZfHgPHZNbE1U=";
    };

    kyle-vm = {
      allowedIPs = [ "192.168.10.69/32" ];
      publicKey = "Lxwg9vozhPFHHzfYYcS3Uu4qIqKEQBAiknodkbGgFB4=";
    };

    plainsoap = {
      allowedIPs = [ "192.168.10.146/32" ];
      publicKey = "Ny174Y9j9hEdtsJsawf6InMa6opVjoAF075gWL42n3g=";
    };

    oganesson = {
      allowedIPs = [ "192.168.10.254" ];
      publicKey = "G2Eoa27pxlD7B2Gy2gKxFTF53y3tmXZCr0monjwtOyg=";
      endpoint = "192.227.194.176:51820";
      persistentKeepalive = 10;
    };
  };
in {
  flake.modules.networks.peridot =
    { config, lib, ... }:
    let
      # TODO: Flake level network handling
      inherit (args.config.flake.nixosConfigurations.fluorine.config.services)
        caddy
        nginx
        ;

      localDNS =
        if caddy.enable
        then map (url: lib.removePrefix "http://" url) (lib.attrNames caddy.virtualHosts)
        else if nginx.enable then lib.attrNames nginx.virtualHosts else [];
    in {
      options.wireguard.peridot.peer = lib.mkOption {
        type = lib.types.enum (lib.attrNames peers);
        default = config.networking.hostName;
      };

      config.networking = {
        hosts."192.168.10.1" = [ "fluorine.lan" ] ++ localDNS;
        wireguard = {
          enable = true;
          interfaces.peridot = {
            ips = lib.mkDefault peers.${config.wireguard.peridot.peer}.allowedIPs;
            listenPort = 51820;
            # TODO: Replace with secrets
            privateKeyFile = "/var/lib/wireguard/key";
            peers = lib.attrValues
              (lib.mapAttrs (peer: config: config // { name = peer; }) peers);
          };
        };
      };
    };
}
