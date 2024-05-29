{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.udiskie;
in
{
  options.shit.udiskie = {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";

      settings = {
        # see https://github.com/coldfix/udiskie/blob/master/doc/udiskie.8.txt#configuration
      };
    };
  };
}
