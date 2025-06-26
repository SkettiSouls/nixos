{ ... }:

{
  flake.roles = {
    desktop = ./desktop.nix;
    gaming = ./gaming.nix;
    workstation = ./workstation.nix;
  };
}
