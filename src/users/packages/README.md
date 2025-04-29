## Wrapper-manger Package Set

The package set for [wrapper-manager](https://github.com/viperML/wrapper-manager) can be handled **one** of **two** ways:

* As a `perSystem` module (`./per-system`):
  - Using this method places user wrappers under `wrappers.<system>.<user>.<package>`, which can be used like so:
      ```nix
      # Flake module
      { inputs, moduleWithSystem, ... }:

      {
        config.flake.nixosModules = moduleWithSystem
          (perSystem@{ config }:
          nixos@{ ... }: # this can be _:
          {
            somePackageOption = perSystem.config.wrappers.<user>.<package>;
          });
      }
      ```
* As a flake module (`./flake-module`):
  - Using this method places user wrappers under `wrappers.<user>.<package>`, which can be used like so:
      ```nix
      # NixOS module
      { self, pkgs, ... }:

      {
        somePackageOption = (self.wrappers { inherit pkgs; }).<user>.<package>;
      }
      ```
