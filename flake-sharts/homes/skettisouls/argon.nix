{ config, lib, pkgs, ... }:

{
  imports = [ ./modules ];

  home.packages = with pkgs;[
    rofi
  ];

  sketti = {
    desktops = {
      river.enable = true;
    };
  };

  shit = {
    audio = {
      bluetooth.enable = true;
    };

    neofetch = {
      trollOS.enable = true;
    };

    hyprland.wallpapers = {
      suncat.source = "/etc/nixos/shit/images/wallpapers/suncat.jpg";
    };

    browsers = {
      default = "brave";
      brave.enable = true;
      qutebrowser.enable = true;
      # schizofox.enable = true;
    };
  };
}
