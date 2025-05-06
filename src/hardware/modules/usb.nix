{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;

  cfg = config.regolith.udiskie;
  mkEnabledOption = desc: mkOption {
    type = types.bool;
    default = true;
    description = desc;
  };
in
{
  options.regolith.udiskie = {
    enable = mkEnabledOption "Udiskie";
    automount = mkEnabledOption "Automatically mount devices with udiskie";
    notify  = mkEnabledOption "Allow udiskie to send popup notifications";

    tray = mkOption {
      type = types.enum [ "always" "never" "auto" ];
      default = "never";
      description = "Show udiskie tray icon";
    };
  };

  config = {
    services = {
      gvfs.enable = true; # For file-manager mounting
      udisks2.enable = true;
    };

    environment.systemPackages = mkIf cfg.enable [ pkgs.udiskie ];
    systemd.user.services.udiskie = mkIf cfg.enable {
      enable = true;
      wantedBy = [ "graphical-session.target" ];

      # Stolen from home-manager
      unitConfig = {
        Description = "udiskie mount daemon";
        Requires = lib.optional (cfg.tray != "never") "tray.target";
        After = [ "graphical-session.target" ]
          ++ lib.optional (cfg.tray != "never") "tray.target";
        PartOf = [ "graphical-session.target" ];
      };

      # Automount and notify are on by default.
      serviceConfig.ExecStart = toString
        ([ "${pkgs.udiskie}/bin/udiskie" "--no-config" ]
        ++ lib.optional (!cfg.automount) "--no-automount"
        ++ lib.optional (!cfg.notify) "--no-notify"
        ++ (if cfg.tray == "auto"
          then ["--smart-tray"]
          else if cfg.tray == "always"
          then ["--tray"]
          else ["--no-tray"]));
    };
  };
}
