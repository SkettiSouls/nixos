{ self, config, lib, ... }:
let
  inherit (self.lib)
    listToAttrs'
    ;

  inherit (lib)
    concatLists
    mapAttrsToList
    mkIf
    mkOption
    toList
    types
    ;

  cfg = config.shit.hyprland;
  monitors = listToAttrs' config.shit.hardware.monitors.monitors;
in
{
  options.shit.hyprland.wallpapers = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        monitors = mkOption {
          type = with types; either (listOf str) str;
          default = monitors.displayPort;
        };

        source = mkOption {
          type = with types; either path str;
          default = "/etc/nixos/shit/images/wallpapers/nixos-frappe.png";
        };
      };
    });
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = mapAttrsToList (name: options: options.source) cfg.wallpapers;
        wallpaper = concatLists (mapAttrsToList (name: options: (map (port: "${port},contain:${options.source}") (toList options.monitors))) cfg.wallpapers);
        splash = false;
      };
    };
  };
}
