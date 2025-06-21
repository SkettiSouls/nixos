{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.regolith.niri;
in
{
  options.regolith.niri = {
    enable = mkEnableOption "Niri";
    withUWSM = mkEnableOption "Universal wayland session manager integration";
    xwayland.enable = mkEnableOption "XWayland";

    package = mkOption {
      type = types.package;
      default = pkgs.niri;
    };
  };

  config = mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];

        programs.dconf.enable = true;
        security.polkit.enable = true;
        services.graphical-desktop.enable = true;

        xdg.portal = {
          enable = true;
          configPackages = [ cfg.package ];
          extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        };
      }

      (mkIf cfg.withUWSM {
        programs.uwsm = {
          enable = true;
          waylandCompositors.niri = {
            prettyName = "Niri";
            comment = "Niri compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/niri-session";
          };
        };
      })

      (mkIf (!cfg.withUWSM) {
        systemd.packages = [ cfg.package ];
        services.displayManager.sessionPackages = [ cfg.package ];
      })

      (mkIf cfg.xwayland.enable {
        environment.systemPackages = [ pkgs.xwayland-satellite ];
        programs.xwayland.enable = true;
      })
    ]
  );
}
