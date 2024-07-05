{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.shit) kitty;

  cfg = config.shit.fetch.trollOS;
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
