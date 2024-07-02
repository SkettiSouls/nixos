{ inputs, self, config, lib, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    # users set by flake.userModules
    extraSpecialArgs = { inherit inputs self; };
  };
}
