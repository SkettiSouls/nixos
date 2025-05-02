{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  mainMod = "Super";
  appMod = "Super_SHIFT";
  defaultHeadphones = config.basalt.headphones.default;
  defaultBrowser = "firefox";

  hypr-pkgs = inputs.hyprland.packages.${pkgs.system};
  cfg = config.basalt.desktops.hyprland;

  bind = mod: key: action: lib.concatStringsSep ", " [ mod key action ];
  bindApps = attrs: lib.attrValues (lib.mapAttrs (key: app: bind appMod key "exec, ${app}") attrs);
  bindWorkspaces = mod: action: map (i: bind mod (toString i) "${action}, ${toString i}") (lib.range 1 9);
in
{
  options.basalt.desktops.hyprland.enable = mkEnableOption "Hyprland";

  config.wayland.windowManager.hyprland = mkIf cfg.enable {
    enable = true;
    # Use nixos module's packages
    package = null;
    portalPackage = null;

    settings = {
      monitor = "DP-1, 1920x1080@60, 0x0, 1";
      workspace = [
        "m[HDMI-A-1], layoutopt:orientation:left"
      ] ++ (map (i: "${toString i}, monitor:HDMI-A-1") (lib.range 1 9));

      general = {
        layout = "master";
      };

      animations = {
        enabled = false;
      };

      input = {
        repeat_rate = 50;
        repeat_delay = 300;
        follow_mouse = 2;
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

      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      misc = {
        disable_hyprland_logo = true;
      };
    };
  };
}
