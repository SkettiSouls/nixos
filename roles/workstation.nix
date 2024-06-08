{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.roles.workstation;
in
{
  options.roles.workstation.enable = mkEnableOption "Workstation role";

  config = mkIf cfg.enable {
    shit = {
      wireguard.enable = true;
      home-manager = {
        enable = true;
      };
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


    i18n = rec {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = defaultLocale;
        LC_IDENTIFICATION = defaultLocale;
        LC_MEASUREMENT = defaultLocale;
        LC_MONETARY = defaultLocale;
        LC_NAME = defaultLocale;
        LC_NUMERIC = defaultLocale;
        LC_PAPER = defaultLocale;
        LC_TELEPHONE = defaultLocale;
        LC_TIME = defaultLocale;
      };
    };

    home-manager.users.skettisouls = {
      shit = {
        bash.enable = true;
        git.enable = true;
        gpg.enable = true;
      };
    };
  };
}
