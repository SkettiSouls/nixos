{ ... }:
{ config, lib, ... }:
let
  inherit (lib) mkIf;

  mainMod = "Super";
  appMod = "${mainMod}_SHIFT";
  altMod = "${mainMod}_CTRL"; # Alternative mod, not `mod_ALT`

  defaultHeadphones = config.basalt.headphones.default;
  defaultBrowser = "firefox";

  cfg = config.basalt.desktops.hyprland;
  hcfg = config.wayland.windowManager.hyprland.settings;

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
  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = rec {
        ipc = "on";
        splash = false;

        preload = [ "/etc/nixos/etc/images/wallpapers/urple.jpg" ];
        wallpaper = [ "HDMI-A-1, ${builtins.head preload}" ];
      };
    };

    wayland.windowManager.hyprland = {
      systemd.enable = false; # Conflicts with `withUWSM` option.
      settings = {
        monitor = "HDMI-A-1, 1920x1080@60, 0x0, 1";
        workspace = [
          "m[HDMI-A-1], layoutopt:orientation:left"
        ] ++ (map (i: "${toString i}, monitor:HDMI-A-1") (lib.range 1 9));

        general = {
          layout = "master";
          border_size = 2;
          gaps_in = 6;
          gaps_out = 12;
          "col.active_border" = "rgba(9522f0d8)";
          # "col.inactive_border" = "rgba(9522f060)";
        };

        animation = [
          "windowsIn, 1, 4, default, gnomed"
          "windowsOut, 1, 5, default, gnomed"
          "windowsMove, 1, 3, default"
          "workspaces, 1, 7, default, slidefade"
          "specialWorkspace, 1, 7, default, fade"
        ];

        cursor.no_warps = true;

        master = {
          mfact = 0.6; # Master window size %, 0.6 for river
          new_status = "master";
          new_on_top = true;
        };

        misc = {
          initial_workspace_tracking = 2;
          enable_anr_dialog = false;
        };

        bind = [
          ", Print, exec, grime copy area"
          "${altMod}, E, exec, uwsm stop"
          "${mainMod}, Q, killactive"
          "${mainMod}, F, fullscreen"
          "${mainMod}, S, togglefloating"
          "${mainMod}, Tab, togglespecialworkspace"
          "${appMod}, Tab, movetoworkspacesilent, special"
          "${mainMod}, RETURN, layoutmsg, swapwithmaster master"
          "${mainMod}, J, layoutmsg, cyclenext"
          "${mainMod}, K, layoutmsg, cycleprev"
          "${appMod}, J, layoutmsg, rollnext"
          "${appMod}, K, layoutmsg, rollprev"
          "${altMod}, R, layoutmsg, mfact exact ${toString hcfg.master.mfact}" # Restore mfact
        ] ++ 
        (bindExec {
          ${mainMod} = {
            B = "chp ${defaultHeadphones}";
            R = "fuzzel --launch-prefix=\"uwsm app -- \"";
          };

          "${appMod}" = {
            RETURN = "kitty";
            B = defaultBrowser;
            D = "discord";
          };

          "${altMod}" = {
            B = "bluetoothctl disconnect ${defaultHeadphones}";
          };
        }) ++
        bindWorkspaces mainMod "workspace" ++
        bindWorkspaces appMod "movetoworkspacesilent";
      };
    };
  };
}
