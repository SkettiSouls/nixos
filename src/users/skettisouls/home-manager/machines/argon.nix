{ pkgs, flakeRoot, ... }:
{
  basalt = {
    audio.bluetooth.enable = true;

    browsers = {
      brave.enable = true;
      qutebrowser.enable = true;
      firefox.enable = true;
    };

    desktops.river.enable = true;

    defaultApps = {
      browser = "firefox";
      launcher = "fuzzel";
    };

    launchers.fuzzel.enable = true;

    neofetch.trollOS.enable = true;

    wallpapers = {
      suncat = "${flakeRoot}/etc/images/wallpapers/suncat.jpg";
    };
  };
}
