{ inputs, ... }:
{
  config.flake.wrapperModules.default = inputs.flake-parts.lib.importApply ./modules/nixos.nix;
}
