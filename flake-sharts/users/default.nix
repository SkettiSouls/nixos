{ config, lib, moduleWithSystem, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  mkModuleSystem = mkOption {
    type = types.deferredModule;
    default = {};
  };

  cfg = config;
in
{
  # TODO: Get all user dirs
  imports = [ ./skettisouls/default.nix ];

  options = {
    users = mkOption {
      # type = with types; attrsOf (listOf (enum config.machines));
      type = with types; attrsOf (submodule {
        options = {
          home-manager.enable = mkEnableOption "Home manager";

          machines = mkOption {
            type = listOf (enum config.machines);
            default = config.machines;
          };

          wrapper-manager = {
            enable = mkEnableOption "Wrapper Manager";
            installedWrappers = mkOption {
              type = listOf str;
              default = [];
            };
          };
        };
      });
    };

    flake.userModules = mkOption {
      type = with types; attrsOf (submodule {
        options = {
          home-manager = mkModuleSystem;
          nixos = mkModuleSystem;
          wrapper-manager = mkModuleSystem;
        };
      });
    };
  };

  config = {
    flake.nixosModules.mkUsers = moduleWithSystem (
      perSystem@{ config }:
      nixos@{ config, ... }: {
        users.users = lib.mapAttrs (user: attrs:
          lib.mkIf (lib.elem nixos.config.networking.hostName attrs.machines) {
            isNormalUser = true;
            extraGroups = lib.mkDefault [ "networkmanager" "wheel" ];
            packages = mkIf attrs.wrapper-manager.enable (map
              (wrp: perSystem.config.wrappedPackages.${user}.${wrp})
            attrs.wrapper-manager.installedWrappers);
          }
        ) cfg.users;
      }
    );
  };
}
