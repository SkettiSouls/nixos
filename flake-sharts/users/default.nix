{ config, lib, ... }:
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
        home-manager  = ./skettisouls/home-manager;
        wrapper-manager = import ./skettisouls/wrapper-manager;
      };
    };

    nixosModules = let
      eachUser = config.homes;
    in
    {
      users = ({ inputs, self, pkgs, config, ... }: {
        # Create all users in `homes`
        users.users = lib.mapAttrs (user: hostList:
          # Check if the host is present in the user's host list
          lib.mkIf (lib.elem config.networking.hostName hostList) {
            isNormalUser = true;
            extraGroups = lib.mkDefault [ "networkmanager" "wheel" ];
            # Wrapper-manager
            packages = [
              (inputs.wrapper-manager.lib.build {
                inherit pkgs;
                specialArgs = { inherit inputs self; };
                modules = [
                  self.userModules.${user}.wrapper-manager
                ];
              })
            ];
          }
        ) eachUser;
      });
    };
  };
}
