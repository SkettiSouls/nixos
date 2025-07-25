{ inputs, ... }:

{
  imports = [ ./quickshell ];

  perSystem = { pkgs, system, inputs', ... }: {
    _module.args.pkgs = (import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: with inputs'; {
          unstable = nixpkgs-unstable.legacyPackages;
        })
      ];
    });

    packages = {
      creek = pkgs.unstable.callPackage ./creek {};
      rebuild = pkgs.callPackage ./rebuild {};
      waterfox = pkgs.callPackage ./waterfox.nix {};
      xdg-desktop-portal-luminous = pkgs.callPackage ./luminous.nix {};
    };
  };
}
