{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.qutebrowser;
in
{
  options.programs.qutebrowser.unbind = mkOption {
    type = types.attrs;
    default = {};
  };
  options.shit.qutebrowser = {
    enable = mkEnableOption "qutebrowser";
    default = mkOption {
      type = types.bool;
      default = true;
    };
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
	  #"d" = null;
	  "dd" = "tab-close";
	};
      };
      unbind = {
        normal = [
	  "d"
	];
      };
      extraConfig = "config.unbind('d', mode='normal')";
      settings = {
        "auto_save.session" = true;
	"colors.webpage.preferred_color_scheme" = "dark";
	"colors.webpage.darkmode.enabled" = true;
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
     
    xdg.mimeApps = mkIf cfg.default {
      enable = true;
      defaultApplications = {
        "browser/internal" = ["org.qutebrowser.qutebrowser.desktop"];
        "text/html" = ["org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/http" = ["org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/https" = ["org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/about" = ["org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/unknown" = ["org.qutebrowser.qutebrowser.desktop"];
      };
    };
  };
}
