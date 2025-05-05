{ ... }:
{ config, lib, ... }:
let
  inherit (lib) mkIf;

  mainMod = "Super";
  appMod = "Super_SHIFT";
  defaultHeadphones = config.basalt.headphones.default;
  defaultBrowser = "firefox";

  cfg = config.basalt.desktops.hyprland;

  bind = mod: key: action: lib.concatStringsSep ", " [ mod key action ];
  bindApps = attrs: lib.attrValues (lib.mapAttrs (key: app: bind appMod key "exec, ${app}") attrs);
  bindWorkspaces = mod: action: map (i: bind mod (toString i) "${action}, ${toString i}") (lib.range 1 9);
in
{
  config.wayland.windowManager.hyprland = mkIf cfg.enable {
    settings = {
      monitor = "HDMI-A-1, 1920x1080@60, 0x0, 1";
      workspace = [
        "m[HDMI-A-1], layoutopt:orientation:left"
      ] ++ (map (i: "${toString i}, monitor:HDMI-A-1") (lib.range 1 9));

      general = {
        layout = "master";
      };

      animations = {
        enabled = false;
      };

      cursor.no_warps = true;

      master = {
        mfact = 0.6; # Master window size %, 0.6 for river
        new_status = "master";
      };

      bind = [
        "${mainMod}_ALT, E, exit"
        "${mainMod}, Q, killactive"
        "${mainMod}, F, fullscreen"
        "${mainMod}, S, togglefloating"
        "${mainMod}, R, exec, fuzzel"
        "${mainMod}, RETURN, layoutmsg, swapwithmaster master"
        "${mainMod}, J, layoutmsg, cyclenext"
        "${mainMod}, K, layoutmsg, cycleprev"
        "${mainMod}, B, exec, chp ${defaultHeadphones}"
        "${mainMod}_ALT, B, exec, bluetoothctl disconnect ${defaultHeadphones}"
        ", Print, exec, grime copy area"
      ] ++
      (bindApps {
        RETURN = "kitty";
        B = defaultBrowser;
        D = "discordcanary";
      }) ++
      bindWorkspaces mainMod "workspace" ++
      bindWorkspaces appMod "movetoworkspacesilent";
    };
  };
}
