{ config, lib, pkgs, ... }:
let
  inherit (config.services)
    caddy
    nginx
    ;

  inherit (lib)
    mkIf
    mkOption
    types
    ;

  multi-mode = "delim ;";
  port = toString config.services.gonic.port;
in
{
  options.services.gonic.port = mkOption {
    type = types.int;
    default = 4747;
  };

  config.services = {
    gonic = {
      enable = true;
      settings = {
        listen-addr = "0.0.0.0:${port}";
        music-path = "/music";
        playlists-path = "/music/playlists";
        podcast-path = "/music/podcasts";
        scan-interval = 360; # Minutes
        multi-value-genre = multi-mode;
        multi-value-artist = multi-mode;
        multi-value-album-artist = multi-mode;
      };
    };

    caddy.virtualHosts."http://gonic.fluorine.lan".extraConfig = mkIf caddy.enable ''
      reverse_proxy http://127.0.0.1:${port}
    '';

    nginx.virtualHosts."gonic.flourine.lan" = mkIf nginx.enable {
      enableACME = false;
      forceSSL = false;
      locations."/".proxyPass = "http://127.0.0.1:${port}/";
    };
  };
}
