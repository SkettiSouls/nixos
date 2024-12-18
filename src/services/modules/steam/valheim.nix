{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (config.services) caddy nginx;

  port = toString 2456;
in
{
  systemd.services.valheim = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Nice = "-5";
      Restart = "always";
      StateDirectory = "valheim";
      User = "valheim";
      WorkingDirectory = "/var/lib/valheim";

      ExecStartPre = [''
        ${pkgs.steamcmd}/bin/steamcmd \
          +login anonymous \
          +force_install_dir $STATE_DIRECTORY \
          +app_update 896660 \
          +quit
      ''];

      ExecStart = ''
        ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 ./valheim_server.x86_65 \
        -name "Basically Hard" \
        -world "JusticeForVirginia" \
        -password "zekesmells" \
        -port ${port} \
        -nographics \
        -batchmode \
        -public 1
      '';
    };

    environment = {
      LD_LIBRARY_PATH = "linux64:${pkgs.glibc}/lib";
    };
  };

  services = {
    caddy.virtualHosts."http://valheim.fluorine.lan".extraConfig = mkIf caddy.enable ''
      reverse_proxy http://127.0.0.1:${port}
    '';

    nginx.virtualHosts."valheim.flourine.lan" = mkIf nginx.enable {
      enableACME = false;
      forceSSL = false;
      locations."/".proxyPass = "http://127.0.0.1:${port}/";
    };
  };
}
