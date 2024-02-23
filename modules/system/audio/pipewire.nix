{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.pipewire;
in
{
  options.shit.pipewire = {
    enable = mkEnableOption "Pipewire system-wide configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [];

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
	support32Bit = true;
      };
    };
  };
}
