{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;

  mkVar = mkOption {
    type = types.str;
    default = "";
  };

  cfg = config.shit.defaultApps;
in
{
  imports = [
    ./discord
    ./mangohud.nix
    ./udiskie.nix
    ./variables.nix

    ### Audio ###
    ./audio/bluetooth.nix
    ./audio/mpv.nix

    ### Browsers ###
    ./browsers/brave.nix
    ./browsers/firefox.nix
    ./browsers/qutebrowser.nix

    ### Desktops ###
    # TODO: Move hyprland here
    ./desktops/portals.nix
    ./desktops/river.nix

    ### Launchers ###
    ./launchers/rofi.nix
    ./launchers/fuzzel.nix

    ### Terminals ###
    ./terminals/kitty.nix

    ### Tools ###
    ./tools/bash.nix
    ./tools/gpg.nix
  ];

  options.shit.defaultApps = {
    launcher = mkVar;
    browser = mkVar;
  };

  config.xdg.browser.default = mkIf (cfg.browser != "") cfg.browser;
}
