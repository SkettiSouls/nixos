{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.roles.gaming;
in
{
  options.shit.roles.gaming.enable = mkEnableOption "Gaming role";

  config = mkIf cfg.enable {
    shit = {
      steam.enable = true;
    };
  };
}
