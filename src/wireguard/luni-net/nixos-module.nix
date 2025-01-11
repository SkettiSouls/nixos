{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.wireguard.luni-net;
in
{
  options.wireguard.luni-net.enable = mkEnableOption "Lunarix's network";

  config = mkIf cfg.enable {
    wireguard.networks.asluni = {
      autoConfig = {
        openFirewall = true;

        "networking.wireguard" = lib.mkForce {
          interface.enable = true;
          peers.mesh.enable = true;
        };

        "networking.hosts" = {
          enable = true;
          FQDNs.enable = true;
        };
      };
    };
  };
}
