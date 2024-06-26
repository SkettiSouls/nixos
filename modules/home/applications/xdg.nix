{ config, lib, ... }:

let
  inherit (lib)
    mkMerge
    mkOption
    optional
    types
    ;

  cfg = config.shit.browsers;
  home = config.home.homeDirectory;

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
in
{
  # Hyprland browser keybind is set to the value of cfg.default. See hyprland.nix:170.
  options.shit.browsers = {
    default = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = {
    xdg = {
      enable = true;
      cacheHome = "${home}/.cache";
      configHome = "${home}/.config";
      dataHome = "${home}/.local/share";
      stateHome = "${home}/.local/state";

      userDirs = {
        enable = true;
        createDirectories = true;

        download = "${home}/Downloads";
        desktop = "${home}/Desktop";
        documents = "${home}/Documents";
        music = "${home}/Music";
        pictures = "${home}/Pictures";
        videos = "${home}/Videos";

        templates = null;
        publicShare = null;

        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
        };
      };

      mimeApps = mkMerge [
        {
          enable = true;
          defaultApplications = {
            "x-scheme-handler/discord" = ["Vesktop.desktop"];
          };
        }
        { defaultApplications = browserMimelist; }
      ];
    };
  };
}
