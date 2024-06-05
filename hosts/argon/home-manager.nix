{ inputs, self, config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.home;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.shit.home.enable = mkEnableOption "temporary solution to per-device home-manager";

  config = mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs self; };

      users = {
        skettisouls = import ../../home.nix;
      };
    };
  };
}
