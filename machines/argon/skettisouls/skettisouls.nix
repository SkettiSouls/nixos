{ config, withSystem, ... }:
let
  inherit (config.flake.machines.argon) users system;
  inherit (withSystem system (a: a)) pkgs;
  inherit (users.skettisouls) wrappers;
in
{
  flake.machines.argon.users.skettisouls = {
    packages = with pkgs; [
      wrappers.niri
      regolith.rebuild

      keepassxc

      # Gaming
      bolt-launcher
      datefudge
      unstable.vintagestory
      nexusmods-app
    ];
  };
}
