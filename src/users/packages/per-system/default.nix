flake@{ inputs, ... }:
{ inputs, config, ... }:

{
  imports = [ ./transpose.nix ];

  perSystem = { system, ... }: {
    wrappers =
      builtins.mapAttrs (_: attrs:
        (inputs.wrapper-manager.lib.eval {
          modules = [ attrs.wrapperModule ];
          specialArgs = { inherit inputs; };
          pkgs = (import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              (final: prev: with flake.inputs; {
                unstable = nixpkgs-unstable.legacyPackages.${system};
              })
            ];
          });
        }).config.build.packages)
      config.flake.users;
  };
}
