{ config, lib, ... }:
let
  inherit (config.services)
    caddy
    forgejo
    nginx
    ;

  inherit (lib) mkIf;

  port = toString forgejo.settings.server.HTTP_PORT;
in
{
  services = {
    forgejo = {
      enable = true;
      database.type = "postgres";

      settings = {
        DEFAULT.APP_NAME = "Forgejo Internal";
        repository.DEFAULT_BRANCH = "master";
        server = rec {
          DOMAIN = "git.fluorine.lan";
          ROOT_URL = "http://${DOMAIN}";
          HTTP_PORT = 3001;
        };
      };
    };

    caddy.virtualHosts."http://git.fluorine.lan".extraConfig = mkIf caddy.enable ''
      reverse_proxy http://127.0.0.1:${port}
    '';

    nginx.virtualHosts."git.fluorine.lan" = mkIf nginx.enable {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${port}/";
      };
    };
  };
}
