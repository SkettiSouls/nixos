{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  mkExtensions = attrs: lib.mapAttrs' (name: id: {
    name = id;
    value = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
      installation_mode = "force_installed";
    };
  }) attrs;

  cfg = config.basalt.browsers.firefox;
in
{
  options.basalt.browsers.firefox = {
    enable = mkEnableOption "Firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # nativeMessagingHosts = with pkgs; [ tridactyl-native ];

      policies = {
        Cookies.Behavior = "reject-tracker-and-partition-foreign";
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;

        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };

        Homepage.URL = "https://search.brave.com";
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        PrivateBrowsingModeAvailability = 2; # 0 - Enabled, 1 - Disabled, 2 - Forced
        SearchBar = "unified";

        # Extensions
        ExtensionSettings = mkExtensions {
          # Theme
          Dark = "firefox-compact-dark@mozilla.org";

          ublock-origin = "uBlock0@raymondhill.net";
          privacy-badger17 = "jid1-MnnxcxisBPnSXQ@jetpack"; # Not sure why 17 is required
          keepassxc-browser = "keepassxc-browser@keepassxc.org";
          sponsorblock = "sponsorBlocker@ajay.app";
          return-youtube-dislikes = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
          vimium-c = "vimium-c@gdh1995.cn";
        };
      };

      /* TODO: User Chrome [
        Remove window buttons ( X, Maximize, Minimize )
        Remove page buttons (back, forward, refresh)
        Take a stab at theming
        *PIPEDREAM* change ui to fit qutebrowser (url inside of the mode indicator of tridactyl, tab number, etc)
      ] */

      profiles.skettisouls = {
        isDefault = true;
        # about:config
        settings = {
          "browser.fullscreen.autohide" = false;
          "browser.toolbars.bookmarks.visibility" = "never";
          "sidebar.main.tools" = "history,bookmarks";
          "sidebar.revamp" = true; # Dependency of `verticalTabs`
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "always-show";
        };

        search = {
          default = "Brave";
          engines = {
            "Brave" = {
              urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
              definedAliases = [ "@b" ];
            };

            "Nix Packages" = {
              urls = [{ template = "https://search.nixos.org/packages?query={searchTerms}"; }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "Nix Options" = {
              urls = [{ template = "https://search.nixos.org/options?query={searchTerms}"; }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            "NixOS Wiki" = {
              urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://wiki.nixos.org/favicon.png";
              definedAliases = [ "@nw" ];
            };

            "Bing".metaData.hidden = true;
          };
        };
      };
    };
  };
}
