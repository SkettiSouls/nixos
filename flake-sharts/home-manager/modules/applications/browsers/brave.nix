{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.browsers.brave;
in
{
  options.shit.browsers.brave = {
    enable = mkEnableOption "brave";
  };

  config = mkIf cfg.enable {
    # TODO: Make this module programs.chromium with brave as the package.
    home.packages = with pkgs; [
      brave
    ];
  };
}
