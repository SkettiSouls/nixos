{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.NAME;
in
{
  options.shit.NAME = {
    enable = mkEnableOption "DESCRIPTION";
  };

  config = mkIf cfg.enable { 
    home.packages = with pkgs; [
      PACKAGE
    ];

    PREFIX.NAME = {
      enable = true;
    };
  };
}
