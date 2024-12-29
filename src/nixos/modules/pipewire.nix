{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.regolith.pipewire;
in
{
  options.regolith.pipewire = {
    enable = mkEnableOption "PipeWire";
  };

  config = mkIf cfg.enable {
    # Enable realtime priority
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      audio.enable = true;
      wireplumber.enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
}
