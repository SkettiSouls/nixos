flake:
{ inputs, config, ... }:
let
  overlay-unstable = system:
  (final: prev: {
    unstable = flake.inputs.nixpkgs-unstable.legacyPackages.${system};
  });
in
{
  imports = [ ./transpose.nix ];

  perSystem = { system, ... }: {
    wrappers = builtins.mapAttrs (_: attrs:
      (inputs.wrapper-manager.lib.eval {
        modules = [ attrs.wrapperModule ];
        specialArgs = { inherit inputs; };
        pkgs = (import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [(overlay-unstable system)];
        });
      }).config.build.packages)
    config.flake.users;
  };
}
