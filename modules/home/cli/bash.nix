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
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rsync
      eza
    ];

    programs.bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      historyControl = [ "ignoredups" ];

      shellAliases = {
        ":q" = " exit";
        cp = "rsync";
        compile = "./compile";
        run = "./run";
        icat = mkIf kitty.enable "kitten icat";
        ls = "eza --icons=always --group-directories-first";
        rebuild = "sudo nixos-rebuild switch; hyprctl reload";
        vim = "nvim";
      };

      # TODO: Make window swallowing override (`spit`).
      # bashrcExtra = ''function spit {
      #   PROMPT_COMMAND="echo -ne \"\033]0;$1 \077""
      # }\n'';
    };
  };
}
