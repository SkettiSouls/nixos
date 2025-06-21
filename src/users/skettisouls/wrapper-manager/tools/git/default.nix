{ config, pkgs, ... }:
let
  gitConfig = pkgs.writeText "gitconfig" ''
    [commit]
      gpgSign = true

    [gpg]
      format = "ssh"

    [gpg "openpgp"]
      program = "${pkgs.gnupg}/bin/gpg"

    [pull]
      rebase = false

    [tag]
      gpgSign = true

    [user]
      email = "skettisouls@gmail.com"
      name = "SkettiSouls"
      signingKey = "/home/skettisouls/.keys/ssh/git.key"
  '';
in
{
  wrappers.git = {
    basePackage = pkgs.git.overrideAttrs (prev: {
      passthru = { inherit gitConfig; };
    });

    extraPackages = [ pkgs.git-extras ];

    env = {
      GIT_CONFIG_GLOBAL.value = "${gitConfig}";
    };
  };

  wrappers.lazygit = {
    basePackage = pkgs.lazygit;
    pathAdd = [ config.wrappers.git.wrapped ];
    prependFlags = [ "--use-config-file" ./lazygit.yml ];
  };
}
