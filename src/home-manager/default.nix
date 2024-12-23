{ config, lib, ... }:
let
  inherit (config.flake.lib) combineModules;

  inherit (lib)
    mkOption
    types
    ;
in
{
  options.flake.homeModules = mkOption {
    type = with types; attrsOf deferredModule;
    default = {};
  };

  config.flake = {
    nixosModules.home-manager = import ./nixos-module.nix;

    homeModules = {
      git = ./modules/git.nix;
      mimelist = import ./modules/mimelist.nix;
      neofetch = import ./modules/neofetch.nix;

      default.imports = combineModules config.flake.homeModules;
    };
  };
}
