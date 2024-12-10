{
  imports = [
    ./luni-net
    ./peridot
  ];

  flake.nixosModules = {
    luni-net = import ./luni-net/nixos-module.nix;
    peridot = import ./peridot/nixos-module.nix;
  };
}
