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
  bindWorkspaces = mod: action: map (i: bind mod (toString i) "${action}, ${toString i}") (lib.range 1 9);

  bindExec = attrs: with builtins;
  let
    rawAttrs = lib.mapAttrsRecursive (k: v: k ++ ["exec, uwsm app -- ${v}"]) attrs;
    concatAttrs = attrs:
      lib.concatMapAttrs (k: v:
        if isAttrs v
        then concatAttrs v
        else { "${head v}.${k}" = v; })
      attrs;
  in
    map
    (lib.concatStringsSep ", ")
    (attrValues (concatAttrs rawAttrs));
in
{
  config.wayland.windowManager.hyprland = mkIf cfg.enable {
    systemd.enable = false; # Conflicts with `withUWSM` option.
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
        ", Print, exec, grime copy area"
        "${mainMod}_ALT, E, exec, uwsm stop"
        "${mainMod}, Q, killactive"
        "${mainMod}, F, fullscreen"
        "${mainMod}, S, togglefloating"
        "${mainMod}, RETURN, layoutmsg, swapwithmaster master"
        "${mainMod}, J, layoutmsg, cyclenext"
        "${mainMod}, K, layoutmsg, cycleprev"
      ] ++ 
      (bindExec {
        ${mainMod} = {
          B = "chp ${defaultHeadphones}";
          R = "fuzzel --launch-prefix=\"uwsm app -- \"";
        };

        "${appMod}" = {
          RETURN = "kitty";
          B = defaultBrowser;
          D = "discordcanary";
        };

        "${mainMod}_ALT" = {
          B = "bluetoothctl disconnect ${defaultHeadphones}";
        };
      }) ++
      bindWorkspaces mainMod "workspace" ++
      bindWorkspaces appMod "movetoworkspacesilent";
    };
  };
}
