{ config, lib, flakeRoot, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.basalt) kitty;

  cfg = config.basalt.neofetch.trollOS;
in
{
  options.basalt.neofetch.trollOS.enable = mkEnableOption "Enable trollOS fetch";

  config.regolith = mkIf cfg.enable {
    neofetch = {
      enable = true;
      distroName = "TrollOS ${config.home.version.release}";
      image = {
        source = "${flakeRoot}/etc/images/fetch/troll3D.png";
        # TODO: Automatically change to the current terminal
        renderer = mkIf kitty.enable "kitty";
        size = "320px";
      };
    };
  };
}
