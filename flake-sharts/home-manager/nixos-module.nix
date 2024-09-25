{ inputs, self, config, lib, ... }:
let
  inherit (config.flake)
    userModules
    homeModules
    machines
    ;

  inherit (lib)
    mapAttrs
    ;
in
{
  config.flake.nixosModules.home-manager = { host, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      extraSpecialArgs = { inherit inputs self; };
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
      users = mapAttrs (user: hostList: let
        nixosConfig = config.flake.nixosConfigurations.${host}.config;
        nixosOptions = config.flake.nixosConfigurations.${host}.options;
      in {
        programs.home-manager.enable = true;

        home = rec {
          username = user;
          homeDirectory = lib.mkDefault "/home/${username}";
          stateVersion = nixosConfig.system.stateVersion;
        };

        imports = [
          userModules.${user}.home-manager
          homeModules.default
          machines.homes.${user}.${host}

          {
            options.roles = nixosOptions.shit.roles;
            config.roles = nixosConfig.shit.roles;
          }
        ];
      }) config.homes;
    };
  };
}
