{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;

  inherit (config.nixcord) vesktop;

  desktopEntries = {
    brave = "brave.desktop";
    qutebrowser = "org.qutebrowser.qutebrowser.desktop";
    schizofox = "Schizofox.desktop";
  };

# browserMimeList {{{
  browserMimelist = let
    browser = desktopEntries.${cfg.default};
  in {
    "browser/internal" = browser;
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "x-scheme-handler/mailto" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "application/json" = browser;
    "application/pdf" = browser;
  };
# }}}

  cfg = config.xdg.browser;
in
{
  options.xdg.browser = {
    default = mkOption {
      type = with types; nullOr (enum (builtins.attrNames desktopEntries));
      default = null;
    };
  };

  config.xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = lib.mkMerge [
        (mkIf (cfg.default != null) browserMimelist)
        {
          "x-scheme-handler/discord" = mkIf vesktop.enable ["Vesktop.desktop"];
        }
      ];
    };
  };
}
