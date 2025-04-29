{ config, lib, ... }:

{
  flake.nixosModules.home-manager = import ./nixos-module.nix;

  # TODO: flake.homeConfigurations
  flake.homeModules = {
    git = import ./modules/git.nix;
    mimelist = import ./modules/mimelist.nix;
    neofetch = import ./modules/neofetch.nix;
    river = import ./modules/river;

    # Pass config.flake down to home scope
    stretch = {
      options.flake = lib.mkOption {
        type = lib.types.unspecified;
        default = config.flake;
        readOnly = true;
      };
    };
  };
}
