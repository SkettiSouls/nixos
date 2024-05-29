{ config, lib, ... }:

let
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.shit.browsers;

  qutebrowser = ["org.qutebrowser.qutebrowser.desktop"];
  brave = ["brave-browser.desktop"];

  isDefaultSet = cfg.default != "";
  isQutebrowser = isDefaultSet && cfg.default == "qutebrowser";
  isBrave = isDefaultSet && cfg.default == "brave";
in
{
  options.shit.browsers = {
  # Hyprland browser keybind is set to the value of cfg.default. See hyprland.nix:170.
    default = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    xdg = {
      enable = true;
      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      stateHome = "${config.home.homeDirectory}/.local/state";

      userDirs = {
        enable = true;
        createDirectories = true;

        download = "${config.home.homeDirectory}/Downloads";
        desktop = "${config.home.homeDirectory}/Desktop";
        documents = "${config.home.homeDirectory}/Documents";
        music = "${config.home.homeDirectory}/Music";
        pictures = "${config.home.homeDirectory}/Pictures";
        videos = "${config.home.homeDirectory}/Videos";

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
        {
          defaultApplications = mkIf isQutebrowser {
            "browser/internal" = qutebrowser;
            "text/html" = qutebrowser;
            "x-scheme-handler/http" = qutebrowser;
            "x-scheme-handler/https" = qutebrowser;
            "x-scheme-handler/about" = qutebrowser;
            "x-scheme-handler/unknown" = qutebrowser;
            "application/x-extension-htm" = qutebrowser;
            "application/x-extension-html" = qutebrowser;
            "application/x-extension-shtml" = qutebrowser;
            "application/x-extension-xht" = qutebrowser;
            "application/x-extension-xhtml" = qutebrowser;
            "application/xhtml+xml" = qutebrowser;
          };
        }
        {
          defaultApplications = mkIf isBrave {
            "browser/internal" = brave;
            "text/html" = brave;
            "x-scheme-handler/http" = brave;
            "x-scheme-handler/https" = brave;
            "x-scheme-handler/about" = brave;
            "x-scheme-handler/unknown" = brave;
            "x-scheme-handler/mailto" = brave;
            "application/x-extension-htm" = brave;
            "application/x-extension-html" = brave;
            "application/x-extension-shtml" = brave;
            "application/x-extension-xht" = brave;
            "application/x-extension-xhtml" = brave;
            "application/xhtml+xml" = brave;
            "application/json" = brave;
            "application/pdf" = brave;
          };
        }
      ];
    };
  };
}
