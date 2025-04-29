{ config, lib, pkgs, host, ... }:
let
  inherit (config.flake) roles machines;
  isGamingRig = lib.elem roles.gaming machines.${host}.roles;
in
{
  config = lib.mkIf isGamingRig {
    roles.gaming.enable = true;

    home = {
      packages = with pkgs; [
        heroic
        lutris
        minetest
        prismlauncher
        unstable.wineWowPackages.staging
        winetricks
      ];
    };
  };
}
