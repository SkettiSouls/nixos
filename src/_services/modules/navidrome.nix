{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (config.services) caddy nginx;

  port = toString config.services.navidrome.settings.Port;
in
{
  services = {
    navidrome = {
      enable = true;
      settings = {
        Port = 4041;
        MusicFolder = "/music/deezer";
        DataFolder = "/var/lib/navidrome";
        SubsonicArtistParticipations = true;
      };
    };

    caddy.virtualHosts."http://navidrome.fluorine.lan".extraConfig = mkIf caddy.enable ''
      reverse_proxy http://127.0.0.1:${port}
    '';

    nginx.virtualHosts."navidrome.flourine.lan" = mkIf nginx.enable {
      enableACME = false;
      forceSSL = false;
      locations."/".proxyPass = "http://127.0.0.1:${port}/";
    };
  };
}
