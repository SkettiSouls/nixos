## Wrapper-manger Package Set

The package set for [wrapper-manager](https://github.com/viperML/wrapper-manager) can be handled **one** of **two** ways:

* As a `perSystem` module (`./per-system.nix`):
  - Using this method places user wrappers under `wrappedPackages.<system>.<user>.<package>`, which can be used like so:
      ```nix
      # Flake module
      { inputs, moduleWithSystem, ... }:

      {
        config.flake.nixosModules = moduleWithSystem (
          perSystem@{ config }:
          nixos@{ ... }: # this can be _:
          {
            somePackageOption = perSystem.config.wrappedPackages.<user>.<package>;
          });
      }
      ```
* As a flake output (`./packages.nix`):
  - Using this method places user wrappers under `wrappedPackages.<user>.<package>`, which can be used like so:
      ```nix
      # NixOS module
      { self, pkgs, ... }:

      {
        somePackageOption = (self.wrappedPackages { inherit pkgs; }).<user>.<package>;
      }
      ```
