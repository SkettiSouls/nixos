{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;

  cfg = config.regolith.networking;
in
{
  options.regolith.networking = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
