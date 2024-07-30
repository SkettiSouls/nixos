{
  imports = [
    ./flake-modules/luni-net.nix
    ./flake-modules/peridot.nix
  ];

  flake.nixosModules = {
    luni-net = import ./nixos-modules/luni-net.nix;
    peridot = import ./nixos-modules/peridot.nix;
  };
}
