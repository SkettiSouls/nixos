{ inputs, config, lib, ... }:
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
  #   hosts = {
  #     "172.16.2.1" = [
  #       "cypress.local"
  #       "sesh.cypress.local"
  #       "tape.cypress.local"
  #       "codex.cypress.local"
  #       "pgadmin.cypress.local"
  #       "chat.cypress.local"
  #     ];
  #   };
    wireguard.networks.asluni = {
      autoConfig = {
        openFirewall = true;

        "networking.wireguard" = {
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
