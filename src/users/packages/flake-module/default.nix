{ self, inputs, config, ... }:

{
  config.flake.wrappers = { pkgs, ... }: builtins.mapAttrs (_: attrs:
    (inputs.wrapper-manager.lib.eval {
      inherit pkgs;
      specialArgs = { inherit self inputs; };
      modules = [
        attrs.wrapperModules
      ];
    }).config.build.packages
  ) config.flake.users;
}
