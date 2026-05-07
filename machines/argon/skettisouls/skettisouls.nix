{ config, ... }:
let
  inherit (config.flake.nixosConfigurations.argon) pkgs;
  inherit (config.flake.machines.argon.users.skettisouls) wrappers;
in
{
  flake.machines.argon.users.skettisouls = {
    packages =  with pkgs; [
      wrappers.niri

      unstable.discord

      # Gaming
      bolt-launcher
      datefudge
      unstable.vintagestory
      nexusmods-app
    ];
  };
}
