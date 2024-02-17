{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.brave;
in
{
  options.shit.brave= {
    enable = mkEnableOption "brave";

    default = mkOption {
      type= types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable { 
    home.packages = with pkgs; [
      brave
    ];

    xdg.mimeApps = mkIf cfg.default {
      enable = true;
      defaultApplications = {
	"browser/internal" = ["brave-browser.desktop"];
	"text/html" = ["brave-browser.desktop"];
	"x-scheme-handler/http" = ["brave-browser.desktop"];
	"x-scheme-handler/htpps" = ["brave-browser.desktop"];
	"x-scheme-handler/about" = ["brave-browser.desktop"];
	"x-scheme-handler/unknown" = ["brave-browser.desktop"];
      };
    };
  };
}
