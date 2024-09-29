{ inputs, self, config, lib, ... }:
let
  inherit (config.flake)
    userModules
    homeModules
    machines
    ;

  inherit (lib)
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  config.flake.nixosModules.home-manager = { host, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    options.users.users = mkOption {
      type = with types; attrsOf (submodule {
        options.home-manager.enable = mkEnableOption "Manage user configs with home-manager";
      });
    };

    config.home-manager = {
      extraSpecialArgs = { inherit inputs self; };
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
      users = mapAttrs (user: hostList: let
        nixosConfig = config.flake.nixosConfigurations.${host}.config;
        nixosOptions = config.flake.nixosConfigurations.${host}.options;
        hm = nixosConfig.users.users.${user}.home-manager;
      in
      {
        programs.home-manager.enable = mkIf hm.enable true;

        home = mkIf hm.enable (rec {
          username = user;
          homeDirectory = lib.mkDefault "/home/${username}";
          stateVersion = nixosConfig.system.stateVersion;
        });

        imports = lib.optionals hm.enable [
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
