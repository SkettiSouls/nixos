{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.roles.workstation;
in
{
  options.shit.roles.workstation.enable = mkEnableOption "Workstation role";

  config = mkIf cfg.enable {
    shit = {
      wireguard.enable = true;
    };

    services = {
      openssh.enable = true;
      udisks2.enable = true;
    };

    environment.systemPackages = with pkgs; [
      btop
      comma
      fzf
      neovim
      unzip
      zip
    ];

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      (nerdfonts.override { fonts = [ "SourceCodePro" "DejaVuSansMono" ]; })
    ];
  };
}
