{ config, lib, pkgs, ... }:
let
  cfg = config.services.steam-dedicated.valheim;
  port = toString cfg.port;
in
{
  systemd.services.valheim.environment.LD_LIBRARY_PATH = "linux64:${pkgs.glibc}/lib";

  services.steam-dedicated = {
    valheim = {
      enable = true;
      port = 2456;
      appId = 892970;

      startCmd = ''
        ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 ./valheim_server.x86_64 \
        -name "Basically Hard" \
        -world "JusticeForVirginia" \
        -password "zekesmells" \
        -port ${port} \
        -nographics \
        -batchmode \
        -public 1
      '';

      serviceConfig = {
        Nice = "-5";
        Restart = "always";
      };
    };
  };
}
