{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.fetch.trollOS;
  kitty = config.shit.kitty;
in
{
  options.shit.fetch.trollOS.enable = mkEnableOption "Enable trollOS fetch";
  config.shit = mkIf cfg.enable {
    fetch = {
      neofetch = {
        enable = true;
        distroName = "TrollOS ${config.home.version.release}";
        image = {
          source = "/etc/nixos/shit/images/fetch/troll3D.png";
          renderer = mkIf kitty.enable "kitty";
          size = "320px";
        };
      };
    };
  };
}
