{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  mkPkgsOption = mkOption {
    type = types.listOf types.package;
    default = [];
  };
in
{
  options.flake.users = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        homes = mkOption {
          type = attrsOf deferredModule;
          default = {};
        };

        wrapperModules = mkOption {
          type = deferredModule;
          default = {};
        };

        groups = mkOption {
          type = listOf str;
          default = [ "networkmanager" "wheel" ];
        };

        packages = {
          "x86_64-linux" = mkPkgsOption;
          "aarch64-linux" = mkPkgsOption;
        };

        shell = mkOption {
          type = nullOr package;
          default = null;
        };
      };
    });
  };

  imports = lib.getModules ./.;
}
