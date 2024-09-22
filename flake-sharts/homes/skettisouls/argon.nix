{
  imports = [ ./modules ];

  shit = {
    audio.bluetooth.enable = true;

    browsers = {
      brave.enable = true;
      # schizofox.enable = true;
    };

    desktops.river.enable = true;

    defaultApps = {
      browser = "qutebrowser";
      launcher = "fuzzel";
    };

    launchers.fuzzel.enable = true;

    neofetch.trollOS.enable = true;

    hyprland.wallpapers = {
      suncat.source = "/etc/nixos/shit/images/wallpapers/suncat.jpg";
    };

    wallpapers = {
      suncat = "/etc/nixos/shit/images/wallpapers/suncat.jpg";
    };
  };
}
