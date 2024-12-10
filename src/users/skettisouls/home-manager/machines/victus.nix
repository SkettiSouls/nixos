{ config, lib, pkgs, flakeRoot, ... }:

{
  home.packages = with pkgs; [
    rofi
  ];

  basalt = {
    audio = {
      bluetooth.enable = true;
    };

    neofetch = {
      trollOS.enable = true;
    };

    hyprland.wallpapers = {
      suncat.source = "${flakeRoot}/etc/images/wallpapers/suncat.jpg";
    };

    browsers = {
      brave.enable = true;
      qutebrowser.enable = true;
    };
  };

  xdg.browser.default = "qutebrowser";
}
