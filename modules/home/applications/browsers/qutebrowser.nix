{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.browsers.qutebrowser;
in
{
  options.shit.browsers.qutebrowser = {
    enable = mkEnableOption "qutebrowser";
  };

  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      enableDefaultBindings = true;
      loadAutoconfig = true;

      keyBindings = {
        insert = {
          "<Escape>" = "mode-leave ;; jseval -q document.activeElement.blur()";
        };
        normal = {
          "," = "tab-prev";
          "." = "tab-next";
          "<" = "back";
          ">" = "forward";
          "<Ctrl+F>" = "hint links spawn mpv {hint-url}";
          "dd" = "tab-close";
        };
      };
      extraConfig = "config.unbind('d', mode='normal')";

      searchEngines = {
        DEFAULT = "https://search.brave.com/search?q={}";
        aw = "https://wiki.archlinux.org/?search={}";
        g = "https://www.google.com/search?hl=en&q={}";
        gh = "https://github.com/search?q={}&type=repositories";
        np = "https://search.nixos.org/packages?channel=23.11&query={}";
        npu = "https://search.nixos.org/packages?channel=unstable&query={}";
        no = "https://search.nixos.org/options?channel=23.11&query={}";
        nou = "https://search.nixos.org/options?channel=unstable&query={}";
        nw = "https://nixos.wiki/index.php?search={}";
        hm = "https://mipmip.github.io/home-manager-option-search/?query={}";
        yt = "https://yewtu.be/search?q={}";
      };

      settings = {
        "url.auto_search" = "naive";
        "auto_save.session" = true;
        "colors.webpage.darkmode.enabled" = false;
        "colors.webpage.darkmode.algorithm" = "lightness-cielab";
        "colors.webpage.preferred_color_scheme" = "dark";
        "colors.webpage.bg" = "";
        "content.autoplay" = false;
        "content.blocking.enabled" = true;
        "content.blocking.method" = "both";
        "content.blocking.hosts.lists" = [
          https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
        ];
        "content.blocking.adblock.lists" = [
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt
          https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt
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

          document.location.href=document.location.href.replace("youtube.com","yewtu.be");
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
  };
}
