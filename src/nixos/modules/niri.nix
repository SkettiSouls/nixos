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
  imports = [ inputs.niri.nixosModules.niri ];

  options.regolith.niri = {
    enable = mkEnableOption "niri";
    withUWSM = mkEnableOption "universal wayland session manager integration";
    xwayland.enable = mkEnableOption "XWayland";
    useUnstable = mkEnableOption "the unstable packages for niri and xwayland-satellite";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    environment.systemPackages =
      lib.optionals cfg.xwayland.enable
      (if cfg.useUnstable
      then [ pkgs.xwayland-satellite-unstable ]
      else [ pkgs.xwayland-satellite-stable ]);

    programs = {
      niri = {
        enable = true;
        package = mkIf cfg.useUnstable pkgs.niri-unstable;
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
