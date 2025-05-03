flake@{ inputs, withArgs, ... }:
{ inputs, config, ... }:

{
  config = {
    flake.nixosModules.overlays =
      withArgs ./nixpkgs.nix { inherit config; };

    perSystem = { system, ... }: {
      _module.args.pkgs = (import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: with flake.inputs; {
            bin = bin.packages.${system};
            self = config.packages;
            unstable = nixpkgs-unstable.legacyPackages.${system};
          })
        ];
      });
    };
  };
}
