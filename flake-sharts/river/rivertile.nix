{ config, lib, ... }:
let
  inherit (lib)
    elem
    mkDefault
    mkIf
    ;

  inherit (cfg.variables)
    modKey
    appMod
    ;

  inherit (config.wayland.windowManager.river.settings) declare-mode;

  rivertile = (cfg.layout.generator == "rivertile");
  cfg = config.shit.river;
in
{
  config.wayland.windowManager.river = mkIf (cfg.enable && rivertile) {
    extraConfig = if cfg.layout.config == null then "rivertile -view-padding 6 -outer-padding 6 &" else cfg.layout.config;
    settings = {
      map = mkDefault {
        normal = mkIf (elem "normal" declare-mode) {
        # Decrease/increase the main ratio of rivertile(1)
        "${modKey} H" = mkDefault "send-layout-cmd rivertile 'main-ratio -0.05'";
        "${modKey} L" = mkDefault "send-layout-cmd rivertile 'main-ratio +0.05'";

        # Increment/decrement the main count of rivertile(1)
        "${appMod} H" = mkDefault "send-layout-cmd rivertile 'main-count +1'";
        "${appMod} L" = mkDefault "send-layout-cmd rivertile 'main-count -1'";

        # Change layout orientation
        "${modKey} Left" = mkDefault "send-layout-cmd rivertile 'main-location left'";
        "${modKey} Down" = mkDefault "send-layout-cmd rivertile 'main-location bottom'";
        "${modKey} Up" = mkDefault "send-layout-cmd rivertile 'main-location top'";
        "${modKey} Right" = mkDefault "send-layout-cmd rivertile 'main-location right'";
      };
    };
    };
  };
}
