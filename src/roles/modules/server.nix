{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.roles.server;
in
{
  options.shit.roles.server.enable = mkEnableOption "Server role";

  config = mkIf cfg.enable {
    services.openssh.enable = true;
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;

    environment.systemPackages = with pkgs; [
      btop
      comma
      fzf
      neovim
      unzip
      zip
    ];
  };
}
