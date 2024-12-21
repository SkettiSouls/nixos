{
  flake = {
    nixosModules.steam-dedicated = import ./nixos.nix;

    serviceModules = {
      ark = import ./ark.nix;
      valheim = import ./valheim.nix;
    };
  };
}
