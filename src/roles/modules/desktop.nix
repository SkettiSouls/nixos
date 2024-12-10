{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.regolith.roles.desktop;
in
{
  options.regolith.roles.desktop.enable = mkEnableOption "Desktop role";

  config = mkIf cfg.enable {
    regolith = {
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
  };
}
