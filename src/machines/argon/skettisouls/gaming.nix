{ inputs, ... }:
{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      bolt-launcher
      datefudge
      unstable.vintagestory
    ];
  };
}
