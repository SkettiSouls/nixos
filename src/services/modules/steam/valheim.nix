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
      appId = 896660;

      startCmd = ''
        ${pkgs.steam-run}/bin/steam-run ./valheim_server.x86_64 \
        -name "Basically Hard" \
        -world "JusticeForVirginia" \
        -password "zekesmells" \
        -port ${port} \
        -nographics \
        -batchmode \
        -public 1
      '';
    };
  };
}
