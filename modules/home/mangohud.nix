{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.mangohud;
in
{
  options.shit.mangohud= {
    enable = mkEnableOption "MangoHUD User Configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mangohud
    ];

    programs.mangohud = {
      enable = true;
      settings = {};
    };
  };
}
