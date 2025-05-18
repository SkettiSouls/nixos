{ ... }:
{ config, lib, ... }:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    ;

  mainMod = "Super";
  cfg = config.basalt.desktops.hyprland;
  mkAllDefault = set: builtins.mapAttrs (_: v: mkDefault v) set;
in
{
  options.basalt.desktops.hyprland.enable = mkEnableOption "Hyprland";

  config.wayland.windowManager.hyprland = mkIf cfg.enable {
    enable = true;
    # Use nixos module's packages
    package = mkDefault null;
    portalPackage = mkDefault null;

    settings = {
      input = mkAllDefault {
        repeat_rate = 50;
        repeat_delay = 300;
        follow_mouse = 2;
        kb_options = "ctrl:nocaps";
      };

      bindm = mkDefault [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      misc = {
        disable_hyprland_logo = mkDefault true;
      };
    };
  };
}
