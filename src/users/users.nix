{ inputs, lib, ... }:
let
  inherit (lib) mkOption types;

  userSubmodule = with types; submodule {
    options = {
      groups = mkOption {
        type = listOf str;
        default = [ "networkmanager" "wheel" ];
      };

      packages = mkOption {
        type = listOf package;
        default = [];
      };

      shell = mkOption {
        type = nullOr package;
        default = null;
      };

      wrappers = mkOption {
        type = lazyAttrsOf package;
        default = {};
      };
    };
  };
in
{
  options.flake.users = mkOption {
    default = {};
    type = with types; attrsOf (attrsWith {
      elemType = userSubmodule;
      lazy = true;
      placeholder = "system";
    });
  };

  config.flake.types = { inherit userSubmodule; };

  config.perSystem = { pkgs, ... }: {
    _module.args = let
      wlib = inputs.wrapper-modules.lib;
      wrap = path: (wlib.evalModule path).config.wrap { inherit pkgs; };
    in { inherit wlib wrap; };
  };
}
