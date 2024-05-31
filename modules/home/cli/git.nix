{ config, lib, ... }:

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
    programs.git = {
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

    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          commit.autoWrapCommitMessage = false;

          mainBranches = [
            "master"
            "main"
            "shit"
          ];
        };
      };
    };
  };
}
