{ flakeRoot, lib, ... }:
{ pkgs, ... }:

{
  imports = lib.applyModules ./.;

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

    browsers = {
      brave = {
        enable = true;
        package = pkgs.unstable.brave;
      };

      qutebrowser = {
        enable = true;
        package = pkgs.unstable.qutebrowser;
      };

      firefox = {
        enable = true;
        package = pkgs.unstable.firefox;
      };
    };

    desktops = {
      hyprland.enable = true;

      river = {
        enable = true;
        windowRules = {
          steam.enable = true;
          keepassxc.enable = true;
        };
      };
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
