{ inputs, ... }:

{
  perSystem = { pkgs, system, inputs', ... }: {
    packages = {
      creek = pkgs.unstable.callPackage ./creek {};
      rebuild = pkgs.callPackage ./rebuild {};
      xdg-desktop-portal-luminous = pkgs.callPackage ./luminous.nix {};
    };

    _module.args.pkgs = (import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: with inputs'; {
          unstable = nixpkgs-unstable.legacyPackages;
        })
      ];
    });
  };
}
