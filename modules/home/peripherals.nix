/* Module for declaring peripherals to be used in other modules. See hyprland.nix:9-11. */
{ config, lib, ... }:

let
  inherit (lib)
    mkForce
    mkOption
    types
    ;

  cfg = config.peripherals;
  bluetooth = config.peripherals.bluetooth;

  # Headphones
  soundcoreSpaceQ45 = "E8:EE:CC:4B:FA:2A";
  sennheiserMomentum4 = "80:C3:BA:3F:EB:B9";
in
{
  options.peripherals = {
    bluetooth = {
      headphones = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = {
    peripherals = {
      bluetooth = {
        # mkForce is used for idiot proofing.
        headphones = mkForce sennheiserMomentum4;
      };
    };
  };
}
