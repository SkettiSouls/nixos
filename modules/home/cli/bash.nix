{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.bash;

  headphones = config.peripherals.bluetooth.headphones;
in
{
  options.shit.bash = {
    enable = mkEnableOption "bash";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      historyControl = [ "ignoredups" ];
      profileExtra = "connect-headphones ${headphones}";
      shellAliases = {
        ":q" = " exit";
        cp = "rsync";
        compile = "./compile";
        run = "./run";
        icat = "kitten icat";
        ls = "eza --icons=always --group-directories-first";
        rebuild = "sudo nixos-rebuild switch; hyprctl reload";
        vim = "nvim";
      };
      /* Eventually will make it so the `spit` command overrides Hyprland window swallowing.
      bashrcExtra = ''function spit {
        PROMPT_COMMAND="echo -ne \"\033]0;$1 \077""
      }\n'';
      */
    };
  };
}
