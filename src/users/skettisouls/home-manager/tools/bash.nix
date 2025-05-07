{ ... }:
{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.basalt) kitty;
  inherit (config.flake.packages.${pkgs.system}) rebuild;

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
        ":q" = " exit";
        icat = mkIf kitty.enable "kitten icat";

        l = "eza -alh";
        ls = "eza";
        la = "eza -a";
        lt = "eza -T";
      };

      # TODO: Make window swallowing override (`spit`).
      # bashrcExtra = ''function spit {
      #   PROMPT_COMMAND="echo -ne \"\033]0;$1 \077""
      # }\n'';
    };
  };
}
