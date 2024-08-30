{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.shit) kitty;

  cfg = config.shit.bash;
in
{
  options.shit.bash = {
    enable = mkEnableOption "bash";
    customScripts = mkEnableOption "Enable all custom scripts";
    aliaspp.enable = mkEnableOption "Activate all Alias++ scripts";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # (mkIf cfg.aliaspp.enable self.rebuild)
      eza
      rsync
      self.rebuild
      # (mkIf cfg.customScripts self.scripts)
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
