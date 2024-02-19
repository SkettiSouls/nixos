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
      mpv
      yt-dlp
    ];
    programs.mpv = {
      enable = true;
    };
  };
}
