{ config, lib, pkgs, ... }:
let
  inherit (config.services)
    caddy
    nginx
    ;

  inherit (lib) mkIf;
in
{
  services = {
    gonic = {
      enable = true;
      settings = {
        music-path = "/music";
        playlists-path = "/music/playlists";
        podcast-path = "/music/podcasts";
        scan-interval = 360; # Minutes
        multi-value-genre = "multi";
        multi-value-artist = "multi";
        multi-value-album-artist = "multi";
      };
    };

    caddy.virtualHosts."http://gonic.fluorine.lan".extraConfig = mkIf caddy.enable ''
      reverse_proxy http://127.0.0.1:4747
    '';

    nginx.virtualHosts."gonic.flourine.lan" = mkIf nginx.enable {
      enableACME = false;
      forceSSL = false;
      locations."/".proxyPass = "http://127.0.0.1:4747/";
    };
  };
}
