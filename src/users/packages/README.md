## Wrapper-manger Package Set

The package set for [wrapper-manager](https://github.com/viperML/wrapper-manager) can be accessed **two** ways:

* In flake-scope using `moduleWithSystem`:
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

* In nixos-scope using `self` and `pkgs`:
  ```nix
  # NixOS module
  # NOTE: Passing down `config.flake` from flake-scope is cleaner than using `self`
  { self, pkgs, ... }:

  {
    somePackageOption = self.wrappers.${pkgs.system}.<user>.<package>;
  }
  ```
