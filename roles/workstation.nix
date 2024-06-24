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

    home-manager.sharedModules = [{
      shit = {
        bash.enable = true;
        git.enable = true;
        gpg.enable = true;
      };
    }];
  };
}
