{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  mkUrl = lib.mapAttrs' (name: id: lib.nameValuePair
    id { install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi"; });

  cfg = config.shit.browsers.schizofox;
in
{
  options.shit.browsers.schizofox = {
    enable = mkEnableOption "funny nix firefox";
    tridactyl.enable = mkEnableOption "tridactyl";
  };

  config = mkIf cfg.enable {
    programs.schizofox = {
      enable = true;
      # package = pkgs.tor-browser;
      theme = {
        # TODO: Change font to Iosevka
        font = "Lexend";
        colors = {
          # TODO: Mess around with colors
          background-darker = "181825";
          background = "1e1e2e";
          foreground = "cdd6f4";
        };

        extraUserChrome = ''
          body {
            color: red !important;
          }
        '';
      };

      search = {
        defaultSearchEngine = "Brave";
        removeEngines = ["Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia (en)"];
        searxUrl = "https://searx.be";
        searxQuery = "https://searx.be/search?q=P{searchTerms}&categories=general";
        addEngines = [
          {
            Name = "Brave";
            Alias = "!b";
            URLTemplate = "https://search.brave.com/search?q={searchTerms}";
          }
          {
            Name = "Youtube";
            Alias = "!y";
            URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
          }
          {
            Name = "Yewtu.be";
            Description = "Invidious instance";
            Alias = "!yt";
            URLTemplate = "https://yewtu.be/search?q={searchTerms}";
          }
          {
            Name = "Arch Wiki";
            Alias = "!aw";
            URLTemplate = "https://wiki.archlinux.org/?search={searchTerms}";
          }
          {
            Name = "GitHub Repos";
            Alias = "!gh";
            URLTemplate = "https://github.com/search?q={searchTerms}&type=repositories";
          }
          {
            Name = "GitHub Users";
            Alias = "!ghu";
            URLTemplate = "https://github.com/search?q={searchTerms}&type=users";
          }
          {
            Name = "Nixos Wiki";
            Alias = "!nw";
            URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
          }
          {
            # Test '/packages?query={}' when 24.05 releases to see if it searches latest release.
            Name = "Nixos Packages";
            Alias = "!np";
            URLTemplate = "https://search.nixos.org/packages?channel=23.11&query={searchTerms}";
          }
          {
            Name = "Nixos Packages Unstable";
            Alias = "!npu";
            URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
          }
          {
            # Test '/options?query={}' when 24.05 releases to see if it searches latest release.
            Name = "Nixos Options";
            Alias = "!np";
            URLTemplate = "https://search.nixos.org/options?channel=23.11&query={searchTerms}";
          }
          {
            Name = "Nixos Options Unstable";
            Alias = "!npu";
            URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
          }
          {
            Name = "Home-manager Modules";
            Alias = "!hm";
            URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
          }
        ];
      };

      security = {
        sanitizeOnShutdown = false;
        sandbox = true;
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0}";
      };

      misc = {
        drm.enable = true;
        disableWebgl = false;
        # startPageURL = "file://${builtins.readFile ./startpage.html}";
      };

      extensions = {
        simplefox.enable = true;
        darkreader.enable = true;
        extraExtensions = mkUrl {
          sponsorblock = "sponsorBlocker@ajay.app";
          # FIXME: Keepassxc doesn't connect to database. https://github.com/schizofox/schizofox/issues/90
          keepassxc-browser = "keepassxc-browser@keepassxc.org";
        };
      };
    };
  };
}
