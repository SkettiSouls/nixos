{ self, inputs, config, ... }:

{
  config.flake.wrappedPackages = { pkgs, ... }: builtins.mapAttrs (_: attrs:
    (inputs.wrapper-manager.lib.eval {
      inherit pkgs;
      specialArgs = { inherit self inputs; };
      modules = [
        attrs.wrapper-manager.modules
      ];
    }).config.build.packages
  ) config.flake.users;
}
