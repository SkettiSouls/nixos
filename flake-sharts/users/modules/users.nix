{ self, options, config, pkgs, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;

  inherit (self)
    homeModules
    ;

  cfg = config.shit.users;
  _options = options.shit.users;
in
{
  options.shit.users = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        # Alternative to `<user> = {};`
        enable = mkEnableOption "Enable users in a nicer looking way";
        extraGroups = mkOption {
          type = with types; listOf str;
          default = [ "networkmanager" "wheel" ];
        };

        packages = mkOption {
          type = with types; listOf package;
          default = [];
        };
      };
    });
  };

  config = {
    users.users = lib.mapAttrs
    (uname: options:
      {
        isNormalUser = true;
        extraGroups = options.extraGroups;
        packages = options.packages;
      }
    ) cfg;

    home-manager.users = lib.mapAttrs
    (uname: options:
      {
        # TODO: Switch to using userModules and homeModules instead of paths
        imports = [
          ../../homes/${uname}/${config.networking.hostName}.nix
          ./${uname}.nix
          homeModules.default
        ];
      }
    ) cfg;

    home-manager.sharedModules = [{
      options.shit.users = _options;
      config.shit.users = lib.mkDefault cfg;
    }];
  };
}
