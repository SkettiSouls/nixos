{ config, lib, ... }:
let
  inherit (lib)
    mkDefault
    mkForce
    ;
in
{
  config.programs = {
    git = {
      enable = mkDefault true;

      signing.key = mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519";
      signing.signByDefault = mkDefault true;

      extraConfig = {
        gpg.format = mkDefault "ssh";
        pull.rebase = mkDefault false;
      };
    };

    lazygit = {
      enable = mkDefault true;
      settings = {
        git = {
          commit.autoWrapCommitMessage = mkDefault false;
          mainBranches = [
            "master"
            "main"
          ];
        };
      };
    };
  };
}
