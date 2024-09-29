flake@{ config, lib, moduleWithSystem, ... }:
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

        nixos = mkOption {
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

  config.flake = {
    userModules = {
      skettisouls = {
        home-manager  = import ./skettisouls/home-manager;
        nixos = moduleWithSystem (import ./skettisouls/nixos);
        wrapper-manager = import ./skettisouls/wrapper-manager;
      };
    };

    nixosModules = flake.lib.mapAttrs' (u: m: flake.lib.nameValuePair "perUser" m.nixos) config.flake.userModules
    // {
      users = ({ config, ... }: {
        # Create all users in `homes`
        users.users = lib.mapAttrs (user: hostList:
          # Check if the host is present in the user's host list
          lib.mkIf (lib.elem config.networking.hostName hostList) {
            isNormalUser = true;
            extraGroups = lib.mkDefault [ "networkmanager" "wheel" ];
          }
        ) flake.config.homes;
      });
    };
  };
}
