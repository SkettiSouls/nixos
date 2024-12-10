/* For some reason, Steam nix options are only available in nixos scope, not home-manager. */
{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.regolith.steam;
  nvidia-offload = config.hardware.nvidia.prime.offload.enable;
in
{
  options.regolith.steam = {
    enable = mkEnableOption "Steam";
    offload.nvidia = mkOption {
      type = types.bool;
      default = nvidia-offload;
    };
  };

  config = mkIf cfg.enable {
    # Enable Steam hardware (Steam Controller, HTC Vive, etc...)
    hardware.steam-hardware.enable = true;
    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          # OBS_VKCAPTURE = true; # TODO: Figure out what this does lol

          ### NVIDIA Offloading ###
          __NV_PRIME_RENDER_OFFLOAD = mkIf cfg.offload.nvidia true;
          __NV_PRIME_RENDER_OFFLOAD_PROVIDER = mkIf cfg.offload.nvidia "NVIDIA-60";
          __GLX_VENDOR_LIBRARY_NAME = mkIf cfg.offload.nvidia "nvidia";
          __VK_LAYER_NV_optimus = mkIf cfg.offload.nvidia "NVIDIA_only";
        };

        # TODO: Figure out what this does
        # extraLibraries = p: with p; [
        #   atk
        # ];
      };
    };
  };
}
