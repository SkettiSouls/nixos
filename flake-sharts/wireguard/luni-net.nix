{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.wireguard;
in
{
  options.shit.wireguard.enable = mkEnableOption "Luni-net";

  config = mkIf cfg.enable {
    networking = {
      hosts = {
        "172.16.2.1" = [
          "cypress.local"
          "sesh.cypress.local"
          "tape.cypress.local"
          "codex.cypress.local"
          "pgadmin.cypress.local"
          "chat.cypress.local"
        ];
      };

      wireguard = {
        networks.asluni.autoConfig = {
          interface = true;
          peers = true;
        };
        interfaces.asluni.generatePrivateKeyFile = true;
      };
    };
  };

}
