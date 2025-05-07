{ pkgs, ... }:

{
  # TODO: More gaming changes
  config = {
    # Enable Steam hardware (Steam Controller, HTC Vive, etc...)
    hardware.steam-hardware.enable = true;
    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true; # Used for obs vulkan capture plugin
        };
      };
    };
  };
}
