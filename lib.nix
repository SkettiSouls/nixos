{ inputs, config, withSystem, ... }:
let
  inherit (inputs.nixpkgs) lib;

  utils = lib.recursiveUpdate {
    # TODO 1: assert if not module
    perSystem = module:
      lib.genAttrs
      config.systems
      (system: withSystem system module);

    mkUsers = system: users:
      lib.genAttrs
      (lib.attrNames users)
      (user: users.${user}.${system});
  } inputs.utils.lib;
in { flake.lib = utils; }
