{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.shit) hyprland;

  cfg = config.shit.udiskie;
in
{
  options.shit.udiskie = {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    services.udiskie = {
      enable = true;
      automount = true;
      # TODO: Switch to dunst.enable once dunst module is made.
      notify = mkIf hyprland.enable true;
      tray = "never";

      settings = {
        # see https://github.com/coldfix/udiskie/blob/master/doc/udiskie.8.txt#configuration
      };
    };
  };
}
