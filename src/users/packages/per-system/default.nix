{ self, inputs, config, ... }:

{
  imports = [ ./transpose.nix ];

  perSystem = { pkgs, ... }: {
    # Export wrapper-manager packages as `wrappers.<system>.<user>.<package-name>`
    wrappers = builtins.mapAttrs (_: attrs:
      (inputs.wrapper-manager.lib.eval {
        inherit pkgs;
        specialArgs = { inherit self inputs pkgs; };
        modules = [
          attrs.wrapperModules
        ];
      }).config.build.packages
    ) config.flake.users;
  };
}
