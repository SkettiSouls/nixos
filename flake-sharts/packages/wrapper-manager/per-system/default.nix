{ self, inputs,  ... }:

{
  imports = [ ./module.nix ];

  perSystem = { pkgs', pkgs, ... }: {
    # Export wrapper-manager packages as `wrappedPackages.<system>.<user>.<package-name>`
    wrappedPackages = builtins.mapAttrs (u: m:
      (inputs.wrapper-manager.lib.eval {
        inherit pkgs;
        specialArgs = { inherit self inputs pkgs'; };
        modules = [
          self.userModules.${u}.wrapper-manager
        ];
      }).config.build.packages
    ) self.userModules;
  };
}
