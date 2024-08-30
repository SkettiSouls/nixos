{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;

  inherit (config.nixcord) vesktop;

# browserMimeList {{{
  browserMimelist = let
    browser = cfg.desktopEntry;
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
      type = types.str;
      default = "";
    };

    desktopEntry = mkOption {
      type = types.str;
      default = if cfg.default != "" then "${cfg.default}.desktop" else "";
    };
  };

  config.xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = browserMimelist // {
        "x-scheme-handler/discord" = mkIf vesktop.enable ["Vesktop.desktop"];
      };
    };
  };
}
