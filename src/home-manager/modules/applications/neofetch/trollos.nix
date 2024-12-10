{ config, lib, flakeRoot, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.shit) kitty;

  cfg = config.shit.neofetch.trollOS;
in
{
  options.shit.neofetch.trollOS.enable = mkEnableOption "Enable trollOS fetch";

  config.shit = mkIf cfg.enable {
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
