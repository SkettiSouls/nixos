{ inputs, self, config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.home-manager;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.shit.home-manager = {
    enable = mkEnableOption "temporary solution to per-device home-manager";
    users = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
      users = cfg.users;
      extraSpecialArgs = { inherit inputs self; };
    };
  };
}
