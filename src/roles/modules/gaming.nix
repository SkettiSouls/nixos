{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.regolith.roles.gaming;
in
{
  options.regolith.roles.gaming.enable = mkEnableOption "Gaming role";

  config = mkIf cfg.enable {
    regolith = {
      steam.enable = true;
    };
  };
}
