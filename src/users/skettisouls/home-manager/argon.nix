{ flakeRoot, withArgs, ... }:
{ pkgs, ... }:

{
  imports = [ (withArgs ./default.nix {}) ];

  home.pointerCursor = {
    name = "phinger-cursor-dark";
    package = pkgs.phinger-cursors;
    size = 24;
    gtk.enable = true;
  };

  basalt = {
    audio.bluetooth.enable = true;
    discord.enable = true;
    kitty.enable = true;
    mpv.enable = true;
    udiskie.enable = true;

    browsers = {
      brave.enable = true;
      qutebrowser.enable = true;
      firefox.enable = true;
    };

    desktops = {
      river.enable = true;
      hyprland.enable = true;
    };

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
