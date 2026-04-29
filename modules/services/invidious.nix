{
  flake.modules.services.invidious =
    { config, lib, ... }:
    let
      inherit (config.services) caddy invidious nginx;
      port = toString invidious.port;
    in {
      services = {
        invidious = {
          enable = true;
          port = 3030;
        };

        caddy.virtualHosts."http://inv.fluorine.lan".extraConfig = lib.mkIf caddy.enable ''
          reverse_proxy http://127.0.0.1:${port}
        '';

        nginx = lib.mkIf nginx.enable {
          virtualHosts."inv.fluorine.lan" = {
            enableACME = false;
            forceSSL = false;
            locations."/".proxyPass = "http://127.0.0.1:${port}/";
          };
        };
      };
    };
}
