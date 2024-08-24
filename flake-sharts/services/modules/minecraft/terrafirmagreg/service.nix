{ config, lib, ... }:
let
  inherit (config.services)
    caddy
    nginx
    minecraft
    ;

  inherit (lib) mkIf;

  port = toString minecraft.terraFirmaGreg.port;
in
{
  services = {
    minecraft.terraFirmaGreg = {
      enable = true;
      allowCracked = true;
      allowedIdleTime = 15;
      args = "-Xmx12048M -Xms2048M";
      motd = "Zeke likes balls";
      worldName = "Monkey Men";
    };

    # TODO: Make proxies work lol
    caddy.virtualHosts."http://minecraft.fluorine.lan/tfg".extraConfig = mkIf caddy.enable ''
      reverse_proxy http://127.0.0.1:${port}
    '';

    nginx.virtualHosts."minecraft.fluorine.lan/tfg" = mkIf nginx.enable {
      enableACME = false;
      forceSSL = false;
      locations."/".proxyPass = "http://127.0.0.1:${port}/";
    };
  };
}
