{ inputs, config, ... }:
{
  imports = [ ./quickshell ];

  perSystem = { pkgs, system, ... }: {
    _module.args.pkgs = (import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "nexusmods-app-0.21.1" ];
      };

      overlays = [
        (final: prev: {
          regolith = config.flake.packages.${system};
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    });

    packages = {
      rebuild = pkgs.callPackage ./rebuild {};
    };
  };
}
