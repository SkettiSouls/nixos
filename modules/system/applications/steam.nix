{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
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

    programs.steam = {
      enable = true;
      package = pkgs.steam-small.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
        };
        extraLibraries = p: with p; [
          atk
        ];
      };
      gamescopeSession = {
        enable = true;
      };
    };

    # Home Manager fixes.
    home-manager.sharedModules = [{
      
      /* Been having issues with hyprland freezing, will see if this is the issue
      # Hyprland steam dropdown menu fix.
      wayland.windowManager.hyprland.settings = {
        windowrulev2 = [
          "stayfocused, title:^()$,class:^(steam)$"
          "minsize 1 1, title:^()$,class:^(steam)$"
        ];
      };
      */

    }];
  };
}
