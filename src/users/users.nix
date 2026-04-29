{ inputs, config, lib, ... }:
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
        type = attrsOf package;
        default = {};
      };
    };
  };
in
{
  options.flake.users = mkOption {
    default = {};
    type = with types; lazyAttrsOf (attrsWith {
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

      import-tree = inputs.import-tree.withLib lib;
      mkWrappers = path: config.flake.lib.listToAttrs'
        (map
        (file:
          let wrapper = wrap file;
          in { "${wrapper.pname}" = wrapper; })
        (import-tree.leafs path));
    in { inherit wlib wrap mkWrappers; };
  };
}
