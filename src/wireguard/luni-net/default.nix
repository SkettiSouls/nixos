{ inputs, lib, config, ... }:
{
  wireguard.networks.lunk.privateKeyFile = "/var/lib/wireguard/privatekey";
  wireguard.networks.lunk = {
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
