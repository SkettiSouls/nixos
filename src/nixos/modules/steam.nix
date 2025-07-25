{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.regolith.steam;

  mkEnabledOption = desc: mkOption {
    type = types.bool;
    default = true;
    description = "Whether to enable " + desc;
  };
in
{
  options.regolith.steam = {
    enable = mkEnableOption "Steam";
    hardware.enable = mkEnabledOption "Steam hardware (Steam Controller, HTC Vice, etc)";
    gamemode.enable = mkEnabledOption "GameMode to optimise system performance on demand";
    gamescopeSession.enable = mkEnableOption "GameScope desktop";
    protontricks.enable = mkEnableOption "protontricks";

    package = mkOption {
      type = types.package;
      default = pkgs.steam;
    };

    # ?TODO?: Assert if non proton package
    protonPackages = mkOption {
      type = with types; listOf package;
      default = [];
      description = ''
        List of proton packages to be added to steam compatibility packages.
        See `options.programs.steam.extraCompatPackages` for more information.
      '';
    };
  };

  config = mkIf cfg.enable {
    hardware.steam-hardware.enable = mkDefault cfg.hardware.enable;
    programs = {
      gamemode.enable = mkDefault true;

      gamescope.enable =
        if cfg.gamescopeSession.enable
        then true
        # `mkDefault true` conflicts with `programs.steam.gamescopeSession.enable = false`.
        else (lib.mkOverride 999 true);

      steam = {
        enable = true;
        package = cfg.package;
        extraCompatPackages = cfg.protonPackages;
        protontricks.enable = mkDefault cfg.protontricks.enable;
      };
    };
  };
}
