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

  cfg = config.shit.browsers.firefox;
in
{
  options.shit.browsers.firefox = {
    enable = mkEnableOption "Firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs; [ tridactyl-native ];

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

        Homepage.URL = "moz-extension://75a9d890-4bca-4c91-9888-97370eaec41e/static/newtab.html";
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
          tridactyl-vim = "tridactyl.vim@cmcaine.co.uk";
          sponsorblock = "sponsorBlocker@ajay.app";
          return-youtube-dislikes = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
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
      };
    };
  };
}
