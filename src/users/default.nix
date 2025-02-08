{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;

  getUserDirs = with builtins; attrNames (lib.filterAttrs (_: v: v == "directory") (readDir ./.));
  userDirs = map (user: ./${user}) getUserDirs;

  machines = builtins.attrNames config.flake.machines;
  cfg = config.flake;

  mkModuleSystem = desc: {
    enable = mkEnableOption desc;
    modules = mkOption {
      type = types.deferredModule;
      default = {};
    };
  };
in
{
  imports = userDirs;

  options.flake.users = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        home-manager = mkModuleSystem "Home manager";
        wrapper-manager = mkModuleSystem "Wrapper manager";

        machines = mkOption {
          type = listOf (enum machines);
          default = machines;
          description = ''
            List of machines to build the user on.
          '';
        };

        packages = mkOption {
          type = listOf package;
          default = [];
          description = ''
            Flake level option for user specific packages.
            Use this to prevent adding users to the wrong machines.
          '';
        };
      };
    });
  };

  config = {
    flake.nixosModules.mkUsers = { config, ... }: let
      inherit (config.networking) hostName;
    in {
      users.users = lib.mapAttrs (user: attrs:
        lib.mkIf (lib.elem hostName attrs.machines) {
          isNormalUser = true;
          extraGroups = lib.mkDefault [ "networkmanager" "wheel" ];
          packages = attrs.packages;
        }
      ) cfg.users;
    };
  };
}
