{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (config) roles;

  isDesktop = roles.desktop.enable;
in
{
  config = mkIf isDesktop {
    home = {
      packages = with pkgs; [
        bin.eat
        element-desktop
        keepassxc
      ];

      pointerCursor = {
        name = "phinger-cursor-dark";
        package = pkgs.phinger-cursors;
        size = 24;
        gtk.enable = true;
      };
    };

    shit = {
      discord.enable = true;
      kitty.enable = true;
      mpv.enable = true;
      udiskie.enable = true;
    };
  };
}
