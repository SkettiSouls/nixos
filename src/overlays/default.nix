{
  # perSystem overlays via `pkgs'`
  imports = [ ./per-system.nix ];

  config.flake = {
    # Home-manager and nixos overlays
    nixosModules.overlays = import ./nixpkgs.nix;

    # Flake overlays
    # overlays = {};
  };
}
