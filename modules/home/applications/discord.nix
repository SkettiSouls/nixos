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
    enable = mkEnableOption "Discord user configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
        withTTS = true;
      })
    ];
  };
}
