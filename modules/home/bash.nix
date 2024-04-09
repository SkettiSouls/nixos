{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.bash;
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
      profileExtra = "bluetoothctl power on && bluetoothctl connect E8:EE:CC:4B:FA:2A\n";
      shellAliases = {
        ":q" = " exit";
        cp = "rsync";
        compile = "./compile";
        run = "./run";
        icat = "kitten icat";
        ls = "eza --icons=always --group-directories-first";
        rebuild = "sudo nixos-rebuild switch; hyprctl reload";
      };
      /* Eventually will make it so the `spit` command overrides Hyprland window swallowing.
      bashrcExtra = ''function spit {
        PROMPT_COMMAND="echo -ne \"\033]0;$1 \077""
      }\n'';
      */
    };
  };
}
