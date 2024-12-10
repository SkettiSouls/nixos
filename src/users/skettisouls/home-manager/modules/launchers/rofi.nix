{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.regolith.river.variables) modKey;

  isDefault = config.basalt.defaultApps.launcher == "rofi";
  cfg = config.basalt.launchers.rofi;
in
{
  options.basalt.launchers.rofi.enable = mkEnableOption "Rofi config";

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      plugins = with pkgs; [
        rofi-calc
        rofi-bluetooth
      ];
    };

    regolith.river = {
      bind.keys.normal = {
        "${modKey} R" = mkIf isDefault "spawn 'rofi -show drun'";
        # TODO: Binds for different modes (i.e. rofi-calc)
      };
    };
  };
}
