{ lib, pkgs, ... }:

{
  config = {
    regolith.pipewire.enable = true;
    security.polkit.enable = true;

    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;

    environment.systemPackages = with pkgs; [
      keepassxc
    ];

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
      nerd-fonts.sauce-code-pro
      nerd-fonts.dejavu-sans-mono
    ];
  };
}
