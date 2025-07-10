{ flakeRoot, lib, ... }:
{ pkgs, ... }:

{
  imports = lib.applyModules ./.;

  home = {
    pointerCursor = {
      name = "phinger-cursor-dark";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
    };

    packages = with pkgs; [ pulsemixer easyeffects ];
  };

  programs.bash.profileExtra = ''
    if uwsm check may-start && uwsm select; then
      exec uwsm start default
    fi
  '';

  services.wpaperd = {
    enable = true;
    settings = {
      any.path = "${flakeRoot}/etc/images/wallpapers/urple.jpg";
    };
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
        package = pkgs.qutebrowser;
      };

      firefox = {
        enable = true;
        package = pkgs.unstable.firefox;
      };
    };

    desktops = {
      hyprland.enable = false;
      niri.enable = true;

      river = {
        enable = false;
        windowRules = {
          steam.enable = true;
          keepassxc.enable = true;
        };
      };
    };

    defaultApps = {
      browser = "brave";
      launcher = "fuzzel";
    };

    launchers.fuzzel.enable = true;

    neofetch.trollOS.enable = true;
  };
}
