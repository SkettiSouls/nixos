{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.basalt.gpg;
  gpgHome = "${config.home.homeDirectory}/.keys/gpg";
in
{
  options.basalt.gpg = {
    enable = mkEnableOption "GPG";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = { GNUPGHOME = gpgHome; };
    programs.gpg = {
      enable = true;
      homedir = gpgHome;
      # homedir = "${config.home.homeDirectory}/.keys/gpg";
      mutableKeys = true;
      mutableTrust = true;
    };

    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      pinentry.package = pkgs.pinentry-qt;
      verbose = true;
    };
  };
}
