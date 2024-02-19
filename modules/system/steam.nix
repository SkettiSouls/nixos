{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.steam ;
in
{
  options.shit.steam = {
    enable = mkEnableOption "Steam Configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steam
    ];

    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
      };
    };
  };
}
