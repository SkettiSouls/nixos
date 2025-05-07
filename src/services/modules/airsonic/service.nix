{ config, lib, pkgs, ... }:
let
  inherit (config.services)
    airsonic
    caddy
    nginx
    ;

  inherit (lib) mkIf;

  port = toString airsonic.port;
  airsonic-advanced = pkgs.callPackage ./package.nix {};
in
{
  services = {
    airsonic = {
      enable = true;
      jre = pkgs.openjdk11;
      jvmOptions = [
        "-server"
        "-Xms4G"
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+DisableExplicitGC"
        "-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=30"
        "-XX:G1MaxNewSizePercent=40"
        "-XX:G1HeapRegionSize=16M"
        "-XX:G1ReservePercent=20"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=25"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
      ];
      maxMemory = 8192;
      war = "${airsonic-advanced}/webapps/airsonic.war";
      listenAddress = "0.0.0.0"; # Allow unproxied connections.
    };

    caddy.virtualHosts."http://airsonic.fluorine.lan".extraConfig = mkIf caddy.enable ''
      reverse_proxy http://127.0.0.1:${port}
    '';

    nginx.virtualHosts."airsonic.flourine.lan" = mkIf nginx.enable {
      enableACME = false;
      forceSSL = false;
      locations."/".proxyPass = "http://127.0.0.1:4040/";
    };

    postgresql = {
      ensureDatabases = [ "airsonic" ];
      authentication = ''
        local airsonic airsonic trust
        host airsonic airsonic 127.0.0.1/32 trust
      '';

      ensureUsers = [{
        name = "airsonic";
        ensureDBOwnership = true;
      }];
    };
  };

  # Add ogg encoder to airsonic.
  environment.systemPackages = with pkgs; [ vorbis-tools ];
  system.activationScripts = {
    oggenc.text = ''
      if [ ! -f /var/lib/airsonic/transcode/oggenc ]; then
        ln -s ${pkgs.vorbis-tools}/bin/oggenc /var/lib/airsonic/transcode/oggenc
      fi
    '';
  };
}
