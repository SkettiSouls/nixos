{ moduleWithSystem, ... }:

{
  imports = [ ./packages/per-system ];

  flake.nixosModules.wrapper-manager = moduleWithSystem (import ./modules/enable.nix);
}
