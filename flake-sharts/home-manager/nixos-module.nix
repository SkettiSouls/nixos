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
      users = mapAttrs (user: hostList: {
        programs.home-manager.enable = true;

        home = rec {
          username = user;
          homeDirectory = lib.mkDefault "/home/${username}";
          stateVersion = self.nixosConfigurations.${host}.config.system.stateVersion;
        };

        imports = [
          ../homes/${user}/${host}.nix
          userModules.${user}
          homeModules.default
        ];
      }) config.homes;
    };
  };
}
