{ pkgs, ... }:
{
  shit = {
    audio.bluetooth.enable = true;

    browsers = {
      brave.enable = true;
      qutebrowser.enable = true;
      firefox.enable = true;
    };

    desktops.river.enable = true;

    defaultApps = {
      browser = "qutebrowser";
      launcher = "fuzzel";
    };

    launchers.fuzzel.enable = true;

    neofetch.trollOS.enable = true;

    hyprland.wallpapers = {
      suncat.source = "/etc/nixos/etc/images/wallpapers/suncat.jpg";
    };

    wallpapers = {
      suncat = "/etc/nixos/etc/images/wallpapers/suncat.jpg";
    };
  };
}
