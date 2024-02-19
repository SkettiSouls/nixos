{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.discord;
in
{
  options.shit.discord = {
    enable = mkEnableOption "Vesktop, noise cancelling, and soundboard.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
        withTTS = true;
      })
      vesktop
      easyeffects
    ];

    shit.easyeffects = {
      enable = true;
      bypass = false;
    };
  };
}
