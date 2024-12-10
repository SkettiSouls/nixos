{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.roles.workstation;
in
{
  options.shit.roles.workstation.enable = mkEnableOption "Workstation role";

  config = mkIf cfg.enable {
    wireguard = {
      peridot.enable = mkDefault true;
      luni-net.enable = mkDefault true;
    };

    services = {
      openssh.enable = true;
      udisks2.enable = true;
    };

    programs = {
      direnv = {
        enable = true;
        silent = true;
      };
    };

    environment.systemPackages = with pkgs; [
      btop
      comma
      devenv
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
