{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;

  mkModuleSystem = mkOption {
    type = types.deferredModule;
    default = {};
  };

  getUserDirs = builtins.attrNames (lib.filterAttrs (_: v: v == "directory") (builtins.readDir ./.));
  userDirs = map (user: ./${user}) getUserDirs;

  machines = (builtins.attrNames config.flake.machines);
  cfg = config.flake;
in
{
  imports = userDirs;

  options.flake = {
    users = mkOption {
      type = with types; attrsOf (submodule {
        options = {
          home-manager = {
            enable = mkEnableOption "Home manager";
            modules = mkModuleSystem;
          };

          machines = mkOption {
            type = listOf (enum machines);
            default = machines;
          };

          wrapper-manager = {
            enable = mkEnableOption "Wrapper Manager";
            modules = mkModuleSystem;
          };
        };
      });
    };
  };

  config = {
    flake.nixosModules.mkUsers = { config, ... }: {
      users.users = lib.mapAttrs (user: attrs:
        lib.mkIf (lib.elem config.networking.hostName machines) {
          isNormalUser = true;
          extraGroups = lib.mkDefault [ "networkmanager" "wheel" ];
        }
      ) cfg.users;
    };
  };
}
