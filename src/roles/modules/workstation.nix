{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    ;

  cfg = config.regolith.roles.workstation;
in
{
  options.regolith.roles.workstation.enable = mkEnableOption "Workstation role";

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
      # Mutually exclusive with nix-index, and depends on channels
      command-not-found.enable = false;
      nix-index = {
        enable = true;
        enableBashIntegration = true;
      };

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
