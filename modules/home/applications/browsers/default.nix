{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.browsers;
in
{
  options.shit.browsers = {
    default = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf (cfg.default != null) {
    xdg.mimeApps = mkIf (cfg.default == "qutebrowser") {
      enable = true;
      defaultApplications = lib.mkMerge [
        (mkIf (cfg.default == "qutebrowser") {
          "browser/internal" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "text/html" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "x-scheme-handler/about" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "x-scheme-handler/unknown" = [ "org.qutebrowser.qutebrowser.desktop" ];
        })
        (mkIf (cfg.default == "brave") {
          "browser/internal" = [ "brave-browser.desktop" ];
          "text/html" = [ "brave-browser.desktop" ];
          "x-scheme-handler/http" = [ "brave-browser.desktop" ];
          "x-scheme-handler/htpps" = [ "brave-browser.desktop" ];
          "x-scheme-handler/about" = [ "brave-browser.desktop" ];
          "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
        })
      ];
    };
  };
}
