flake@{ inputs, lib, ... }:
{ inputs, self, config, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  mkModulesOption = mkOption {
    type = types.listOf types.deferredModule;
    default = [];
  };
in
{
  options.flake.machines = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        hardware = mkModulesOption;
        networks = mkModulesOption;

        modules = mkOption {
          type = listOf deferredModule;
        };

        roles = mkOption {
          type = listOf unspecified;
          default = [];
        };

        system = mkOption {
          type = enum config.systems;
          default = "x86_64-linux";
        };

        users = mkOption {
          type = attrsOf (submodule {
            options = {
              homeModule = mkOption {
                type = nullOr deferredModule;
                default = null;
              };

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
            };
          });
          default = {};
        };
      };
    });
  };

  imports = lib.applyModules ./.;

  config.flake = let
    inherit (config.flake) machines nixosModules;
    hostList = lib.attrNames machines;
  in {
    nixosConfigurations = lib.genAttrs hostList
    (host: let
      inherit (machines.${host}) users system;
      hm.enable = with builtins;
        if users != {}
        then elem true
          (attrValues
          (mapAttrs (_: v:
            if v.homeModule != null
            then true
            else false)
          users))
        else false;
    in lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs self; };
      modules =
        machines.${host}.modules
        ++ machines.${host}.hardware
        ++ machines.${host}.roles
        ++ machines.${host}.networks
        ++ lib.combineModulesExcept [ "home-manager" ] nixosModules
        ++ [
          { networking.hostName = host; }
          {
            nixpkgs.overlays = [
              (final: prev: with flake.inputs; {
                bin = bin.packages.${system};
                polyphasia = polyphasia.packages.${system}.default;
                regolith = config.flake.packages.${system};

                unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
        ]
        ++ lib.optionals (users != {}) [{
          users.users = lib.mapAttrs (user: attrs: {
            isNormalUser = true;
            extraGroups = attrs.groups;
            packages = attrs.packages;
            shell = lib.mkIf (attrs.shell != null) attrs.shell;
          }) users;
        }]
        ++ lib.optionals hm.enable [
          nixosModules.home-manager
          {
            config.home-manager.users =
              lib.mapAttrs (user: attrs: {
                imports = [
                  attrs.homeModule
                  config.flake.users.${user}.homeModule
                ];
              }) users;
          }
        ];
    });
  };
}
