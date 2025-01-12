{
  imports = [
    ./luni-net
  ];

  flake = {
    nixosModules = {
      luni-net = import ./luni-net/nixos-module.nix;
      peridot = import ./peridot;
    };
  };
}
