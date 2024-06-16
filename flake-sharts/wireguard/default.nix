_: { config, inputs, ... }:

{
  flake.nixosModules.wireguard = import ./luni-net.nix;

  wireguard = {
    enable = true;

    networks.asluni = {
      peers.by-name = {
        argon.privateKeyFile = "/var/lib/wireguard/privatekey";
        fluorine.privateKeyFile = "/var/lib/wireguard/privatekey";
      };
    };
  };
}
