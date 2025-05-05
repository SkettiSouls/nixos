{ inputs, config, ... }:

{
  imports = [ ./transpose.nix ];

  perSystem = { pkgs, ... }: {
    wrappers =
      builtins.mapAttrs (_: attrs:
        (inputs.wrapper-manager.lib.eval {
          inherit pkgs;
          specialArgs = { inherit inputs; };
          modules = [ attrs.wrapperModule ];
        }).config.build.packages)
      config.flake.users;
  };
}
