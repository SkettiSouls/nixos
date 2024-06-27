{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../modules/home
  ];

  home.packages = with pkgs; [
    rofi
  ];

  shit = {
    audio = {
      bluetooth.enable = true;
    };

    hyprland.wallpapers = {
      suncat.source = "/etc/nixos/shit/images/wallpapers/suncat.jpg";
    };

    browsers = {
      brave.enable = true;
    };
  };
}
