{ inputs, self, config, lib, ... }:
let
  inherit (self)
    userModules
    homeModules
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
        nixosConfig = self.nixosConfigurations.${host}.config;
        nixosOptions = self.nixosConfigurations.${host}.options;
      in {
        programs.home-manager.enable = true;

        home = rec {
          username = user;
          homeDirectory = lib.mkDefault "/home/${username}";
          stateVersion = nixosConfig.system.stateVersion;
        };

        imports = [
          ../homes/${user}/${host}.nix
          ../homes/${user}/modules
          userModules.${user}
          homeModules.default

          {
            options.roles = nixosOptions.shit.roles;
            config.roles = nixosConfig.shit.roles;
          }
        ];
      }) config.homes;
    };
  };
}
