{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.shit.river.variables) modKey;

  isDefault = config.shit.defaultApps.launcher == "fuzzel";
  cfg = config.shit.launchers.fuzzel;
in
{
  options.shit.launchers.fuzzel.enable = mkEnableOption "Fuzzel config";

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

    shit.river = {
      bind.keys.normal = {
        "${modKey} R" = mkIf isDefault "spawn 'fuzzel'";
      };
    };
  };
}
