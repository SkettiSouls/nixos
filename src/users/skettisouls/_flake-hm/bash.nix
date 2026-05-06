{ inputs, ... }:
{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.basalt) kitty;
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (config.flake.packages.${system}) rebuild;
  inherit (inputs.neovim.packages.${system}) neovim-impure;

  cfg = config.basalt.bash;
in
{
  options.basalt.bash.enable = mkEnableOption "bash";

  config = mkIf cfg.enable {
    home.packages = [ rebuild ];

    programs.bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      historyControl = [ "ignoredups" ];

      shellAliases = {
        ":q" = "exit";
        v = "${neovim-impure}/bin/nvim";
        icat = mkIf kitty.enable "kitten icat";

        l = "eza -alh";
        ls = "eza";
        la = "eza -a";
        lt = "eza -T";
      };
    };
  };
}
