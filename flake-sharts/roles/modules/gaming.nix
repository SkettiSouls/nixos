{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.roles.gaming;
in
{
  options.roles.gaming.enable = mkEnableOption "Gaming role";

  config = mkIf cfg.enable {
    shit = {
      steam.enable = true;
      home-manager.enable = true;
    };

    home-manager.sharedModules = [{
      shit = {
        mangohud.enable = true;
      };

      home.packages = with pkgs; [
        heroic
        lutris
        minetest
        prismlauncher
        scarab
        wineWowPackages.staging
        winetricks
      ];
    }];
  };
}
