/* For some reason, Steam nix options are only available in nixos scope, not home-manager. */
{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.applications.steam;
in
{
  options.shit.applications.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    # Enable Steam hardware (Steam Controller, HTC Vive, etc...)
    hardware.steam-hardware.enable = true;

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      package = pkgs.steam-small.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
        };

        extraLibraries = p: with p; [
          atk
        ];
      };
    };
  };
}
