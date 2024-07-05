{ self, options, config, pkgs, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.shit.users;
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
  };
}
