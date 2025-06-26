{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in
{
  # TODO: More gaming changes
  config = {
    # Enable Steam hardware (Steam Controller, HTC Vive, etc...)
    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
      heroic
      prismlauncher
      unstable.wineWowPackages.staging
      winetricks
    ];

    programs = {
      gamemode.enable = mkDefault true;
      gamescope.enable = lib.mkOverride 999 true; # `mkDefault true` conflicts with `programs.steam.gamescopeSession = false`.

      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [ unstable.proton-ge-bin steamtinkerlaunch ];
        package = mkDefault (pkgs.steam.override {
          extraEnv = {
            MANGOHUD = true;
            OBS_VKCAPTURE = true; # Used for obs vulkan capture plugin
          };
        });
      };
    };
  };
}
