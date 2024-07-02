{ config, lib, ... }:

{
  config.flake.homeModules = {
    hyprland = import ./hyprland.nix;
  };
}
