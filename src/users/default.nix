# Non-machine specific user configs
{ lib, ... }:

{
  imports = lib.applyModules ./.;

  options.flake.users = lib.mkOption {
    type = with lib.types; attrsOf (submodule {
      options = {
        homeModule = lib.mkOption {
          type = deferredModule;
          default = {};
        };

        wrapperModule = lib.mkOption {
          type = deferredModule;
          default = {};
        };
      };
    });
  };
}
