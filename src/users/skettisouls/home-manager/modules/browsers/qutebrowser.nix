{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.basalt.browsers.qutebrowser;
in
{
  options.basalt.browsers.qutebrowser = {
    enable = mkEnableOption "QuteBrowser user configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gobble
      rofi # qute-keepassxc
    ];

    programs.qutebrowser = {
      enable = true;
      package = pkgs.unstable.qutebrowser;
      enableDefaultBindings = true;
      loadAutoconfig = true;

      keyBindings = {
        normal = {
          "," = "tab-prev";
          "." = "tab-next";
          "<" = "back";
          ">" = "forward";
          "dd" = "tab-close";
          "uu" = "undo";
          "rr" = "reload";
          "pw" = "spawn --userscript qute-keepassxc --key 682D163ED56008C1A787BCEA6E9A2F35535BE87F";
          "<Ctrl+F>" = "hint links spawn gobble brave {hint-url}";
          "<Ctrl+G>" = "spawn gobble brave {url}";
        };

        insert = {
          "<Escape>" = "mode-leave ;; jseval -q document.activeElement.blur()";
          "<Ctrl+P>" = "spawn --userscript qute-keepassxc --key 682D163ED56008C1A787BCEA6E9A2F35535BE87F";
        };
      };

      extraConfig = ''
        config.unbind('d', mode='normal')
        config.unbind('u', mode='normal')
        config.unbind('r', mode='normal')
        c.content.headers.custom = {"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
      '';

      searchEngines = {
        DEFAULT = "https://search.brave.com/search?q={}";
        g = "https://www.google.com/search?hl=en&q={}";
        aw = "https://wiki.archlinux.org/?search={}";
        gh = "https://github.com/{}";
        ghr = "https://github.com/search?q={}&type=repositories";
        nix = "https://noogle.dev/q?term={}";
        np = "https://search.nixos.org/packages?query={}";
        npu = "https://search.nixos.org/packages?channel=unstable&query={}";
        no = "https://search.nixos.org/options?query={}";
        nou = "https://search.nixos.org/options?channel=unstable&query={}";
        nw = "https://wiki.nixos.org/w/index.php?search={}";
        hm = "https://home-manager-options.extranix.com/?query={}&release=master";
        yt = "https://www.youtube.com/results?search_query={}";
        inv = "http://inv.fluorine.lan/search?q={}";
      };

      settings = {
        "url.auto_search" = "naive";
        "auto_save.session" = true;
        "downloads.prevent_mixed_content" = true;
        "colors.webpage.darkmode.enabled" = false;
        "colors.webpage.darkmode.algorithm" = "lightness-cielab";
        "colors.webpage.preferred_color_scheme" = "dark";
        "colors.webpage.bg" = "";
        "content.autoplay" = false;
        "content.blocking.enabled" = true;
        "content.blocking.method" = "both";
        "content.headers.user_agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36";
        "content.headers.accept_language" = "en-US,en;q=0.5";

        "content.blocking.hosts.lists" = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];

        "content.blocking.adblock.lists" = [
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/lan-block.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt"
          "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
        ];
      };

      greasemonkey = [
        /*
        (pkgs.writeText "yewtube.js" ''
          // ==UserScript==
          // @name         Youtube to Yewtube
          // @version      0.1
          // @description  none
          // @author       You
          // @include      *youtube.com*
          // @run-at       document-start
          // ==/UserScript==

          document.location.href=document.location.href.replace("youtube.com","inv.fluorine.lan");
        '')
        */

        (pkgs.writeText "yt-forward.js" ''
          // ==UserScript==
          // u/name 	  Fast Forward YouTube Ads
          // u/version 	  1.0.0
          // u/description  Speed up and skip YouTube ads automatically
          // u/author       jso8910
          // u/match	  *://*.youtube.com/*
          // u/exclude      *://*.youtube.com/subscribe_embed?*
          // ==/UserScript==
          setInterval(() => {
              const btn = document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button')
              if (btn) {
                  btn.click()
              }
              const ad = [...document.querySelectorAll('.ad-showing')][0];
              if (ad) {
                  document.querySelector('video').playbackRate = 15;
              }
          }, 50)
        '')
      ];
    };

    # Required for `qute-keepassxc` userscript
    basalt.gpg.enable = true;
  };
}
