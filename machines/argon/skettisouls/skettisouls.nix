{ config, withSystem, ... }:
let
  inherit (config.flake.machines.argon) users system;
  inherit (users.skettisouls) wrappers;
in
{
  flake.machines.argon.users.skettisouls = withSystem system ({ pkgs, ... }: {
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
  });
}
