# TODO: Expand this module once I have a laptop again.
{ self, config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.regolith.hardware) laptop;
in
{
  options.regolith.hardware.laptop = mkEnableOption "Set device as a laptop";

  config = mkIf laptop {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];
  };
}
