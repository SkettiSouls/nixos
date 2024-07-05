{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.bash;
  kitty = config.shit.kitty;
in
{
  options.shit.bash = {
    enable = mkEnableOption "bash";
    customScripts = mkEnableOption "Enable all custom scripts";
    aliaspp.enable = mkEnableOption "Activate all Alias++ scripts";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (mkIf cfg.aliaspp.enable sketti.aliaspp)
      eza
      rsync
      sketti.rebuild
      (mkIf cfg.customScripts sketti.scripts)
    ];

    programs.bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      historyControl = [ "ignoredups" ];

      shellAliases = {
        ":q" = " exit";
        cp = "rsync";
        icat = mkIf kitty.enable "kitten icat";
        ls = "eza --icons=always --group-directories-first";
      };

      # TODO: Make window swallowing override (`spit`).
      # bashrcExtra = ''function spit {
      #   PROMPT_COMMAND="echo -ne \"\033]0;$1 \077""
      # }\n'';
    };
  };
}
