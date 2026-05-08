{
  flake.modules.nixos.display =
    { lib, pkgs, ... }:
    {
      security.polkit.enable = true;
      xdg.portal.enable = lib.mkDefault true;

      services = {
        graphical-desktop.enable = true;
        xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;
      };

      programs = {
        dconf.enable = lib.mkDefault true;
        xwayland.enable = lib.mkDefault true;
        uwsm.enable =  lib.mkDefault true;
      };

      # TODO 3: Move to skettisouls.bundles.desktop when that exists
      environment.systemPackages = [ pkgs.keepassxc ];

      fonts.packages = with pkgs; [
        noto-fonts-cjk-sans
        nerd-fonts.sauce-code-pro
        nerd-fonts.dejavu-sans-mono
      ];
    };
}
