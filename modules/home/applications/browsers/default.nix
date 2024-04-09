{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.shit.browsers;
  isDefaultSet = cfg.default != "";
  isQutebrowser = isDefaultSet && cfg.default == "qutebrowser";
  isBrave = isDefaultSet && cfg.default == "brave";
  isFirefox = isDefaultSet && cfg.default == "firefox";
in
{
  options.shit.browsers = {
    default = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkMerge [
  # Hyprland browser keybind is set to the value of cfg.default. See hyprland.nix:170.
    {
      xdg.mimeApps = mkIf isQutebrowser {
        enable = true;
        defaultApplications = {
          "browser/internal" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "text/html" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "x-scheme-handler/about" = [ "org.qutebrowser.qutebrowser.desktop" ];
          "x-scheme-handler/unknown" = [ "org.qutebrowser.qutebrowser.desktop" ];
        };
      };
    }
    {
      xdg.mimeApps = mkIf isBrave {
        enable = true;
        defaultApplications = {
          "browser/internal" = [ "brave-browser.desktop" ];
          "text/html" = [ "brave-browser.desktop" ];
          "x-scheme-handler/http" = [ "brave-browser.desktop" ];
          "x-scheme-handler/https" = [ "brave-browser.desktop" ];
          "x-scheme-handler/about" = [ "brave-browser.desktop" ];
          "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
        };
      };
    }
  ];
}
