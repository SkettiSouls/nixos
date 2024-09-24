{ pkgs, ... }:
let
  gitConfig.init = builtins.readFile ./gitconfig;
  gitConfig.addGPG = gitConfig.init + ''
    program = "${pkgs.gnupg}/bin/gpg2"
  '';
  gitConfig.final = pkgs.writeText "gitconfig-final" gitConfig.addGPG;
in
{
  wrappers.git = {
    basePackage = pkgs.gitFull;
    extraPackages = [ pkgs.git-extras ];

    env = {
      GIT_CONFIG_GLOBAL.value = gitConfig.final;
    };
  };

  wrappers.lazygit = {
    basePackage = pkgs.lazygit;

    flags = [ "--use-config-file" ./lazygit.yml ];
  };
}
