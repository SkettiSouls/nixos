{ self, inputs, config, ... }:

{
  imports = [ ./module.nix ];

  perSystem = { pkgs', pkgs, ... }: {
    # Export wrapper-manager packages as `wrappedPackages.<system>.<user>.<package-name>`
    wrappedPackages = builtins.mapAttrs (_: attrs:
      (inputs.wrapper-manager.lib.eval {
        inherit pkgs;
        specialArgs = { inherit self inputs pkgs'; };
        modules = [
          attrs.wrapper-manager.modules
        ];
      }).config.build.packages
    ) config.flake.users;
  };
}
