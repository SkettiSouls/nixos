{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;

  mkVar = mkOption {
    type = types.str;
    default = "";
  };

  cfg = config.basalt.defaultApps;
in
{
  imports = lib.getModules ./.;

  options.basalt.defaultApps = {
    launcher = mkVar;
    browser = mkVar;
  };

  config.xdg.browser.default = mkIf (cfg.browser != "") cfg.browser;
}
