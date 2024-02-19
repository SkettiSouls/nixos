{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.git;
in
{
  options.shit.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs.git = rec {
      enable = true;

      userName = "SkettiSouls";
      userEmail = "skettisouls@gmail.com";

      signing.key = config.home.homeDirectory + "/.ssh/id_ed25519";
      signing.signByDefault = true;

      extraConfig = {
	gpg.format = "ssh";
        pull.rebase = false;
      };
    };
  };
}
