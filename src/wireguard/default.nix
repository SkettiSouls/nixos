{
  imports = [
    ./luni-net
    ./peridot
  ];

  wireguard.enable = true;

  flake.nixosModules = {
    luni-net = import ./luni-net/nixos-module.nix;
    peridot = import ./peridot/nixos-module.nix;
  };
}
