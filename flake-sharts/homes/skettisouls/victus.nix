{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
  ];

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
      default = "qutebrowser";
      brave.enable = true;
      qutebrowser.enable = true;
    };
  };
}
