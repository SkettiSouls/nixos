{ pkgs, ... }:

{
  config.xdg.portal = {
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
