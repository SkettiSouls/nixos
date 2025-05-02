{ config, lib, pkgs, ... }:
let
  notHypr = !(config.basalt.desktops.hyprland.enable);
in
{
  config.xdg.portal = lib.mkIf notHypr {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];

    config = {
      common = {
        default = [
          "gtk"
        ];

        "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
      };
    };
  };
}
