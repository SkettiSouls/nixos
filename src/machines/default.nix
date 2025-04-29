{ inputs, self, config, lib, ... }:
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
          type = with types; listOf deferredModule;
        };

        roles = mkOption {
          type = with types; listOf unspecified;
          default = [];
        };

        system = mkOption {
          type = types.enum config.systems;
          default = "x86_64-linux";
        };

        users = mkOption {
          type = with types; listOf str;
          default = [];
        };
      };
    });
  };

  imports = lib.getModules ./.;

  config.flake = let
    inherit (config.flake) flakeRoot machines nixosModules users;
    hostList = lib.attrNames machines;
  in {
    nixosConfigurations = lib.genAttrs hostList
    (host: let
      hm = with builtins;
        elem true
          (map (user: hasAttr host users.${user}.homes) machines.${host}.users);
    in lib.nixosSystem {
      inherit (machines.${host}) system;
      specialArgs = { inherit inputs self flakeRoot lib; };
      modules =
        machines.${host}.modules
        ++ machines.${host}.hardware
        ++ machines.${host}.roles
        ++ machines.${host}.networks
        ++ lib.combineModulesExcept [ "home-manager" ] nixosModules
        ++ [
          { networking.hostName = host; }
          (if hm then nixosModules.home-manager else {})

          {
            # Build users
            config.users.users = lib.mapAttrs (user: attrs:
              lib.mkIf (lib.elem user machines.${host}.users) {
                isNormalUser = true;
                extraGroups = attrs.groups;
                packages = attrs.packages.${machines.${host}.system};
                shell = lib.mkIf (attrs.shell != null) attrs.shell;
              }) users;
          }

          # mkIf causes build failure on fluorine (doesn't prevent evaluation)
          (if hm then {
            config.home-manager.users = lib.mkIf hm
              (lib.mapAttrs (user: attrs: { imports = [ attrs.homes.${host} ]; }) users);
          } else {})
        ];
    });
  };
}
