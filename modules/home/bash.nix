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
        cp="rsync";
        play = ''mpv "$(fzf)" '';
        yt = "ytfzf -l -s";
        compile = "./compile";
        run = "./run";
        icat = "kitten icat";
        ls="eza --icons=always --group-directories-first";
        vesktop = "vencorddesktop";
	rebuild = "sudo nixos-rebuild switch; hyprctl reload";
      };
    };
  };
}
