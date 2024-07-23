{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.roles.desktop;
in
{
  options.shit.roles.desktop.enable = mkEnableOption "Desktop role";

  config = mkIf cfg.enable {
    shit = {
      pipewire.enable = true;
    };

    security = {
      polkit.enable = true;
    };

    services = {
      xserver = {
        enable = true;
        displayManager.lightdm.enable = lib.mkForce false;
        xkb = {
          layout = "us";
          variant = "";
        };
      };
    };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      (nerdfonts.override { fonts = [ "SourceCodePro" "DejaVuSansMono" ]; })
    ];

    # TODO: mkIf logic
    home-manager.users.skettisouls = {
      home = {
        pointerCursor = {
          name = "phinger-cursor-dark";
          package = pkgs.phinger-cursors;
          size = 24;
          gtk.enable = true;
        };

        packages = with pkgs; [
          bin.eat
          element-desktop
        ];
      };

      shit = {
        discord.enable = true;
        hyprland.enable = true;
        kitty.enable = true;
        mpv.enable = true;
        udiskie.enable = true;

        audio = {
          carla.enable = true;
        };
      };
    };
  };
}
