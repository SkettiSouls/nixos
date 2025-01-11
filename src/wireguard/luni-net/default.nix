{ lib, ... }:

{
  wireguard.networks.asluni.privateKeyFile = "/var/lib/wireguard/privatekey";
  wireguard.networks.asluni = {
    domainName = "lan";
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
}
