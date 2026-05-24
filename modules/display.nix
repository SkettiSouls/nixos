{
  flake.modules.nixos.display =
    { lib, pkgs, ... }:
    {
      security.polkit.enable = true;

      xdg.portal = {
        config.common = {}; # Disable warning
        enable = lib.mkDefault true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      services = {
        graphical-desktop.enable = true;
        xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;
      };

      programs = {
        dconf.enable = lib.mkDefault true;
        xwayland.enable = lib.mkDefault true;
        uwsm.enable =  lib.mkDefault true;
      };

      environment.systemPackages = [ pkgs.wl-clipboard ];

      fonts.packages = with pkgs; [
        noto-fonts-cjk-sans
        nerd-fonts.sauce-code-pro
        nerd-fonts.dejavu-sans-mono
      ];
    };
}
