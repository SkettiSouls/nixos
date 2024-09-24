{ self, inputs, ... }:

{
  imports = [ ./wrapper-manager/per-system.nix ];

  perSystem = { pkgs, inputs', ... }: let
    callPackageUnstable = inputs'.nixpkgs-unstable.legacyPackages.callPackage;
  in
  {
    packages = {
      creek = callPackageUnstable ./creek {};
      rebuild = pkgs.callPackage ./aliaspp/rebuild.nix {};
      xdg-desktop-portal-luminous = pkgs.callPackage ./luminous.nix {};
    };

    # Export wrapper-manager packages as `wrappedPackages.<system>.<user>.<package-name>`
    wrappedPackages = builtins.mapAttrs (u: m:
      (inputs.wrapper-manager.lib.eval {
        inherit pkgs;
        specialArgs = { inherit self inputs; };
        modules = [
          self.userModules.${u}.wrapper-manager
        ];
      }).config.build.packages
    ) self.userModules;
  };
}
