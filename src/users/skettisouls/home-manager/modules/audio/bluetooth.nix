{ ... }:
{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.basalt) headphones;

  cfg = config.basalt.audio.bluetooth;
in
{
  options.basalt.audio.bluetooth = {
    enable = mkEnableOption "BlueTooth user configuration";
  };

  config = mkIf cfg.enable {
    # FIXME: Fails on first login after reboot.
    programs.bash.profileExtra = "chp ${headphones.default}"; # Connect headphones automatically on login/ ensure connection on rebuild.

    services.mpris-proxy.enable = true;

    xdg.configFile = {
      "wireplumber/wireplumber.conf.d/51-disable-hsp-codec.conf".text = ''
        wireplumber.settings = {
          ## Disable automatic switching
          bluetooth.autoswitch-to-headset-profile = false
        }

        monitor.bluez.properties = {
          ## Only enable a2dp (highest quality, no mic support)
          bluez5.roles = [ a2dp_sink a2dp_source ]
        }
      '';
    };
  };
}
