{ config, lib, pkgs, host, ... }:
let
  inherit (config.flake) roles machines;
  isDesktop = lib.elem roles.desktop machines.${host}.roles;
in
{
  config = lib.mkIf isDesktop {
    roles.desktop.enable = true;

    home = {
      packages = with pkgs; [
        keepassxc
      ];

      pointerCursor = {
        name = "phinger-cursor-dark";
        package = pkgs.phinger-cursors;
        size = 24;
        gtk.enable = true;
      };
    };

    basalt = {
      discord.enable = true;
      kitty.enable = true;
      mpv.enable = true;
      udiskie.enable = true;
    };
  };
}
