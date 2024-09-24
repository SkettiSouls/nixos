{ inputs, self, ... }:

{
  config.flake.wrappedPackages = { pkgs, ... }: builtins.mapAttrs (u: m:
    (inputs.wrapper-manager.lib.eval {
      inherit pkgs;
      specialArgs = { inherit self inputs; };
      modules = [
        self.userModules.${u}.wrapper-manager
      ];
    }).config.build.packages
  ) self.userModules;
}
