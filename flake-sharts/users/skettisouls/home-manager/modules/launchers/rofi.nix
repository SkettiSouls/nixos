{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.shit.river.variables) modKey;

  isDefault = config.shit.defaultApps.launcher == "rofi";
  cfg = config.shit.launchers.rofi;
in
{
  options.shit.launchers.rofi.enable = mkEnableOption "Rofi config";

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      plugins = with pkgs; [
        rofi-calc
        rofi-bluetooth
      ];
    };

    shit.river = {
      bind.keys.normal = {
        "${modKey} R" = mkIf isDefault "spawn 'rofi -show drun'";
        # TODO: Binds for different modes (i.e. rofi-calc)
      };
    };
  };
}
