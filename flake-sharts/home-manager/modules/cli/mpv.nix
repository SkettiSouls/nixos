{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.mpv;
in
{
  options.shit.mpv = {
    enable = mkEnableOption "mpv";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sketti.play
      yt-dlp
    ];

    programs.mpv = {
      enable = true;

      profiles = {
        "extension.mp3" = {
          video = "no";
        };
        "extension.opus" = {
          video = "no";
        };
        "extension.flac" = {
          "video" = "no";
        };
        "extension.fnv" = {
          video = "no";
          volume = 170;
        };
        "extension.gif" = {
          osc = "no";
          loop-file = true;
        };
      };

      scripts = with pkgs.mpvScripts; [
        mpris
      ];
    };
  };
}
