{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.regolith.river.variables) modKey;

  isDefault = config.basalt.defaultApps.launcher == "fuzzel";
  cfg = config.basalt.launchers.fuzzel;
in
{
  options.basalt.launchers.fuzzel.enable = mkEnableOption "Fuzzel config";

  config = mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${pkgs.kitty}/bin/kitty";
          layer = "overlay";
          show-actions = true;
          fields = "filename,name,generic,categories";
          lines = 20;
          width = 40;
          vertical-pad = 10;
          horizontal-pad = 20;
        };
      };
    };

    regolith.river = {
      bind.keys.normal = {
        "${modKey} R" = mkIf isDefault "spawn 'fuzzel'";
      };
    };
  };
}
