/* Module for declaring peripherals to be used in other modules. See hyprland.nix:9-11. */
{ lib, ... }:

let
  inherit (lib)
    mkOption
    types
    ;

in
{
  options.peripherals = {
    bluetooth = {
      headphones = mkOption {
        type = types.str;
        default = "";
      };

      controller = mkOption {
        type = types.str;
        default = "";
      };
    };
  };
}
