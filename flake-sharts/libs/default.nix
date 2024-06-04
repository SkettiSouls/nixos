_: { config, inputs, lib, self, ... }:
let
  # FIXME: use pkgs from flake-parts somehow
  pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
in
{
  flake = {
    lib = {
      combineModules = import ./combine-modules.nix { inherit lib; };

      mkHome = cfg: inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs self; };

        modules = [
          config.flake.homeModules.default
          ../../overlays.nix
          cfg
        ];
      };

      mkNixos = cfg: inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs self; };

        modules = [
          config.flake.nixosModules.default
          ../../shared.nix # will exist when I fully convert to flake-parts.
          ../../overlays.nix
          cfg
        ];
      };
    };

    libraries = config.flake.lib;
  };
}
