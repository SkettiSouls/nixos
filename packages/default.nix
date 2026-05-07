{ inputs, config, ... }:
{
  imports = [ ./quickshell ];

  perSystem = { pkgs, system, inputs', ... }: {
    _module.args.pkgs = (import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          regolith = config.flake.packages.${system};
          unstable = inputs'.nixpkgs-unstable.legacyPackages;
        })
      ];
    });

    packages = {
      rebuild = pkgs.callPackage ./rebuild {};
    };
  };
}
