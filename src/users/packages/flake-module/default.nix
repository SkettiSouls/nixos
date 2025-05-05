{ self, inputs, config, ... }:

{
  config.flake.wrappers = { pkgs, ... }: builtins.mapAttrs (_: attrs:
    (inputs.wrapper-manager.lib.eval {
      inherit pkgs;
      specialArgs = { inherit self inputs; };
      modules = [
        attrs.wrapperModule
      ];
    }).config.build.packages
  ) config.flake.users;
}
