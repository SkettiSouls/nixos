{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.name;
in
{
  options.shit.name = {
    enable = mkEnableOption "desc";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ];

    prefix.name = {
      enable = true;
    };
  };
}
