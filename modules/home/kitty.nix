{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.kitty;
in
{
  options.shit.kitty = {
    enable = mkEnableOption "Kitty configuration";
  };

  config = mkIf cfg.enable { 
    home.packages = with pkgs; [
      kitty
    ];

    programs.kitty = {
      enable = true;
      
    };
  };
}
