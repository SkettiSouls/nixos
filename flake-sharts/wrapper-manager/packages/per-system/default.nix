{ self, inputs,  ... }:

{
  imports = [ ./option.nix ];

  perSystem = { pkgs', ... }: {
    # Export wrapper-manager packages as `wrappedPackages.<system>.<user>.<package-name>`
    wrappedPackages = builtins.mapAttrs (u: m:
      (inputs.wrapper-manager.lib.eval {
        pkgs = pkgs';
        specialArgs = { inherit self inputs; };
        modules = [
          self.userModules.${u}.wrapper-manager
        ];
      }).config.build.packages
    ) self.userModules;
  };
}
