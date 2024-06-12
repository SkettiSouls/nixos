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
      applications.steam.enable = true;
      home-manager.enable = true;
    };

    home-manager.users.skettisouls = {
      shit = {
        mangohud.enable = true;
      };

      home.packages = with pkgs; [
        prismlauncher
        lutris
        wineWowPackages.staging
        winetricks
        heroic
        scarab
        minetest
      ];
    };
  };
}
