{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  home.packages = with pkgs;[
    rofi
  ];

  shit = {
    audio = {
      bluetooth.enable = true;
    };

    desktops = {
      river.enable = true;
    };

    neofetch = {
      trollOS.enable = true;
    };

    hyprland.wallpapers = {
      suncat.source = "/etc/nixos/shit/images/wallpapers/suncat.jpg";
    };

    browsers = {
      brave.enable = true;
      qutebrowser.enable = true;
      # schizofox.enable = true;
    };
  };

  xdg.browser.default = "brave";
}
