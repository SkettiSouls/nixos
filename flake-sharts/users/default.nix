{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options.flake.userModules = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        home-manager = mkOption {
          type = deferredModule;
          default = {};
        };

        wrapper-manager = mkOption {
          type = deferredModule;
          default = {};
        };
      };
    });
  };

  config.flake.userModules = {
    skettisouls = {
      home-manager  = ./skettisouls/home-manager;
      wrapper-manager = ./skettisouls/wrapper-manager;
    };
  };
}
