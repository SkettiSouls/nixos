{ inputs, ... }:
{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      bolt-launcher
      datefudge
      unstable.vintagestory
      nexusmods-app # Readded because its better than vortex for prototyping mods
    ];
  };
}
