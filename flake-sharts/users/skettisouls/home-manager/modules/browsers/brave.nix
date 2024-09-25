{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  isDefault = config.xdg.browser.default == "brave";
  cfg = config.shit.browsers.brave;
in
{
  options.shit.browsers.brave = {
    enable = mkEnableOption "brave";
  };

  config = mkIf cfg.enable {
    xdg.browser.desktopEntry = mkIf isDefault "brave-browser.desktop";
    # TODO: Make this module programs.chromium with brave as the package.
    home.packages = with pkgs; [
      brave
    ];
  };
}
