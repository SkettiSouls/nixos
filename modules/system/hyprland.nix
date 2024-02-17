{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.hyprland;
in
{
  options.shit.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      dunst
      grimblast
      hyprpaper
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
	xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

}
