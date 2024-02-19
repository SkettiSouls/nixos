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
      soundux
    ];

    home.file = {
      ".config/VencordDesktop/VencordDesktop/themes/midnight.css".source = ../../shit/vesktop/themes/midnight.css;
      ".config/VencordDesktop/VencordDesktop/themes/catppuccin-mocha.css".source = ../../shit/vesktop/themes/catppuccin-mocha.css;
      ".config/VencordDesktop/VencordDesktop/themes/ClearVision_v6.css".source = ../../shit/vesktop/themes/ClearVision_v6.css;
    };
    shit.easyeffects = {
      enable = true;
      bypass = false;
    };
  };
}
