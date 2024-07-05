{ inputs, self, config, lib, ... }:
let
  inherit (self)
    userModules
    homeModules
    ;

  inherit (config.flake.lib)
    listToAttrs'
    ;

  inherit (lib)
    mapAttrs
    ;
in
{
  config.flake.nixosModules.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      extraSpecialArgs = { inherit inputs self; };
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
      users = mapAttrs (user: hostList:
        listToAttrs' (map (host: {
          programs.home-manager.enable = true;

          home = rec {
            username = user;
            homeDirectory = lib.mkDefault "/home/${username}";
          };

          imports = [
            # TODO: Replace homes path with a flake module
            ../homes/${user}/${host}.nix
            userModules.${user}
            homeModules.default
          ];
        }) hostList)
      ) config.homes;
    };
  };
}
