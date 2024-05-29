{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  soundcoreSpaceQ45 = "E8:EE:CC:4B:FA:2A";
  sennheiserMomentum4 = "80:C3:BA:3F:EB:B9";
  headphones = sennheiserMomentum4;
  connectHeadphones = "bluetoothctl power on && bluetoothctl connect ${headphones}";
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
      profileExtra = connectHeadphones;
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
