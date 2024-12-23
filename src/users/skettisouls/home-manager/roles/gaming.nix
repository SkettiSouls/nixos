{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (config) roles;

  isGamingRig = roles.desktop.enable && roles.gaming.enable;
in
{
  config = mkIf isGamingRig {
    home = {
      packages = with pkgs; [
        heroic
        lutris
        minetest
        prismlauncher
        wineWowPackages.staging
        winetricks
      ];
    };
  };
}
