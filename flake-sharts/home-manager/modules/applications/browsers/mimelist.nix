{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    optional
    types
    ;

  inherit (config.nixcord) vesktop;

  brave = "brave-browser.desktop";
  qutebrowser = "org.qutebrowser.qutebrowser.desktop";
  schizofox = "Schizofox.desktop";

  isDefaultSet = cfg.default != "";
  isBrave = isDefaultSet && cfg.default == "brave";
  isQutebrowser = isDefaultSet && cfg.default == "qutebrowser";
  isSchizofox = isDefaultSet && cfg.default == "schizofox";

  browser = optional isQutebrowser qutebrowser
    ++ optional isBrave brave
    ++ optional isSchizofox schizofox
    ;

# browserMimeList {{{
  browserMimelist = {
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

  cfg = config.shit.browsers;
in
{
  options.shit.browsers = {
    default = mkOption {
      type = types.str;
      default = "";
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
