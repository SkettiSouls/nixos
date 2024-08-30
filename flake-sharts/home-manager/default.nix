{ config, lib, ... }:
let
  inherit (config.flake.lib)
    combineModules
    ;

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

  config.flake.homeModules = {
    bluetooth = import ./modules/bluetooth.nix;
    mimelist = import ./modules/applications/mimelist.nix;
    peripherals = import ./modules/peripherals.nix;
    udiskie = import ./modules/udiskie.nix;

    # Application modules
    carla = import ./modules/applications/carla.nix;
    mangohud = import ./modules/applications/mangohud.nix;
    neofetch = import ./modules/applications/neofetch;

    # CLI modules
    bash = import ./modules/cli/bash.nix;
    git = import ./modules/cli/git.nix;
    gpg = import ./modules/cli/gpg.nix;
    mpv = import ./modules/cli/mpv.nix;

    default.imports = combineModules config.flake.homeModules;
  };
}
