{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options.shit.hardware = {
    laptop = {
      internalMonitor = mkOption {
        type = types.str;
        default = "eDP-1";
      };

      externalMonitors = mkOption {
        type = with types; either str (listOf str);
        default = [];
      };

      lidSwitch = mkOption {
        type = types.str;
        default = "";
      };
    };
  };
}
