{ inputs, withSystem, ... }:

{
  config = {
    flake = {
      # Home-manager and nixos overlays
      nixosModules.overlays = import ./nixpkgs.nix;

      # Flake overlays (unsure of use-case)
      # overlays = {};
    };

    perSystem = { system, ... }: {
      _module.args.pkgs = (import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: withSystem system ({ config, inputs', ... }: {
            bin = inputs'.bin.packages;
            self = config.packages;
            unstable = inputs'.nixpkgs-unstable.legacyPackages;
          }))
        ];
        config.allowUnfree = true;
      });
    };
  };
}
