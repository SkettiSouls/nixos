{ inputs, ... }:
{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.regolith.niri;
in
{
  options.regolith.niri = {
    enable = mkEnableOption "niri";
    package = lib.mkPackageOption pkgs "niri" {};
    withUWSM = mkEnableOption "universal wayland session manager integration";
    xwayland.enable = mkEnableOption "XWayland";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      lib.optionals cfg.xwayland.enable
      [ pkgs.xwayland-satellite ];

    programs = {
      niri = {
        enable = true;
        package = cfg.package;
      };

      uwsm = mkIf cfg.withUWSM {
        enable = true;
        waylandCompositors.niri = {
          prettyName = "Niri";
          comment = "Niri compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/niri-session";
        };
      };

      xwayland.enable = cfg.xwayland.enable;
    };
  };
}
