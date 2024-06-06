_: { config, inputs, ... }:

{
  flake.nixosModules.wireguard = import ./luni-net.nix;

  imports = with inputs; [
    lynx.flakeModules.flake-guard
    asluni.flakeModules.asluni
  ];

  wireguard = {
    enable = true;

    networks.asluni = {
      peers.by-name = {
        argon.privateKeyFile = "/var/lib/wireguard/privatekey";
        fluorine.privateKeyFile = "";
      };
    };
  };
}
