{ config, lib, ... }:
let
  inherit (lib)
    mkDefault
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

      signing.key = mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519";
      signing.signByDefault = true;

      extraConfig = {
        gpg.format = "ssh";
        pull.rebase = lib.mkForce false;
      };
    };

    programs.lazygit = {
      enable = mkDefault true;
      settings = {
        git = {
          commit.autoWrapCommitMessage = mkDefault false;
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
