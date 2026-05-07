{ config, lib, ... }:
let
  inherit (config.services)
    caddy
    deemix-server
    nginx
    ;

  inherit (lib) mkIf;

  port = toString deemix-server.port;
in
{
  services = {
    deemix-server = {
      enable = true;
      listenAddress = "0.0.0.0";
    };

    caddy.virtualHosts."http://deemix.fluorine.lan".extraConfig = mkIf caddy.enable ''
      reverse_proxy http://127.0.0.1:${port}
    '';

    # FIXME: "Couldn't connect to local server."
    # Seemingly only happens with nginx (tested with wireguard, caddy, and local IP)
    nginx.virtualHosts."deemix.fluorine.lan" = mkIf nginx.enable {
      enableACME = false;
      forceSSL = false;
      locations."/".proxyPass = "http://127.0.0.1:${port}/";
    };
  };
}
