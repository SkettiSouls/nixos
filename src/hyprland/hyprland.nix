# TODO: Move this out of regolith and into basalt
{ config, lib, pkgs, flakeRoot, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  inherit (config.peripherals.bluetooth)
    headphones
    defaultHeadphones
    ;

  cfg = config.basalt.hyprland;
  home = config.home.homeDirectory;
in
{
  imports = [
    ./monitors.nix
  ];

  options.basalt.hyprland = {
    enable = mkEnableOption "Hyprland user configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      slurp
      hyprpicker-git
      (grimblast.override {
        # Change hyprpicker dependency version to flake to prevent core dumps.
        hyprpicker = pkgs.hyprpicker-git;
      })
      wl-clipboard
      dunst
      bin.chp
    ];

    xdg.portal = {
      enable = true;
      config.common.default = "hyprland";
      extraPortals = with pkgs; [
        xdph-git
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland-git;
      xwayland.enable = true;
      settings = {
        exec-once = [
          "hyprpaper &"
          "dunst &"
          "polkit &"
          "chp ${defaultHeadphones}"
          "[workspace 10 silent] carla ${flakeRoot}/etc/carla/system.carxp"
          "[workspace 1 silent] qutebrowser"
          "[workspace 2 silent] vesktop"
          "[workspace 3 silent] steam"
        ];

        "env" = [
          "XCURSOR_THEME,phinger-cursors-dark"
          "XCURSOR_SIZE,24"
        ];

        input = {
          kb_layout = "us";
          # kb_variant =
          # kb_model =
          # kb_options =
          # kb_rules =

          follow_mouse = 1;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/
          gaps_in = 0;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          # "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";
        };

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/
          rounding = 0;

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };

          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        animations = {
          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/
          enabled = "yes";

          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
          ];

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/
          pseudotile = "yes"; # master switch for psuedotiling. mainMod + P
          preserve_split = true; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/
          # new_is_master = true; # Becomes new_status in 0.41.0 and later.
          new_status = "slave";
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/
          workspace_swipe = "off";
        };

        # Custom Variables
        "$mainMod" = "SUPER";
        "$TERM" = "kitty";

        # TODO: Better binds system.
        bind = [
          # System Binds
          "$mainMod, Q, killactive"
          #"$mainMod, E, wlogout -p layer-shell"
          "$mainMod ALT, E, exit"
          "$mainMod, S, togglefloating"
          #"$mainMod, R, exec, wofi --show drun"
          #"$mainMod ALT, R, exec, update-desktop-database"
          "$mainMod, P, pseudo"
          "$mainMod, V, togglesplit"
          "$mainMod, F, fullscreen"
          "$mainMod, RETURN, exec, $TERM"
          "$mainMod, B, exec, chp ${defaultHeadphones}"
          "$mainMod ALT, B, exec, bluetoothctl disconnect ${defaultHeadphones}"
          "$mainMod, C, exec, $TERM -e nvim ${flakeRoot}"
          "$mainMod ALT, C, exec, $TERM -e nvim ${flakeRoot}/src/hyprland/hyprland.nix"

          # App Binds (SUPER_SHIFT)
          "$mainMod SHIFT, B, exec, qutebrowser"
          "$mainMod SHIFT ALT, B, exec, brave"
          "$mainMod SHIFT, D, exec, [workspace 2 silent] vesktop"
          "$mainMod SHIFT, S, exec, [workspace 3 silent] steam"

          # Grimblast Screenshot && Copy
          ", PRINT, exec, grimblast -f copy output"
          " SHIFT, PRINT, exec, grimblast -f copy area"
          " CTRL, PRINT, exec, grimblast -f copy screen"

          # Grimblast Screenshot && CopySave
          "$mainMod, PRINT, exec, grimblast -f copy output && wl-paste > ${home}/Pictures/screenshots/Screenshot-$(date +%F_%T).png"
          "$mainMod SHIFT, PRINT, exec, grimblast -f copy area && wl-paste > ${home}/Pictures/screenshots/Screenshot-$(date +%F_%T).png"
          "$mainMod CTRL, PRINT, exec, grimblast -f copy screen && wl-paste > ${home}/Pictures/screenshots/Screenshot-$(date +%F_%T).png"

          # Navigation
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          # W/ Vim Keys
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          # TODO: Make it more like a DE ( swap back and forth, show windows )
          # DE like alt tab
          "ALT, TAB, cyclenext"
          "ALT, TAB, bringactivetotop"

          # Switch Workspaces (SUPER + [0-9])
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod, TAB, togglespecialworkspace"

          # Move to Workspace
          "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
          "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
          "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
          "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
          "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
          "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
          "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
          "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
          "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
          "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
          "$mainMod SHIFT, TAB, movetoworkspacesilent, special"
          # W/ Focus
          "$mainMod CTRL, 1, movetoworkspace, 1"
          "$mainMod CTRL, 2, movetoworkspace, 2"
          "$mainMod CTRL, 3, movetoworkspace, 3"
          "$mainMod CTRL, 4, movetoworkspace, 4"
          "$mainMod CTRL, 5, movetoworkspace, 5"
          "$mainMod CTRL, 6, movetoworkspace, 6"
          "$mainMod CTRL, 7, movetoworkspace, 7"
          "$mainMod CTRL, 8, movetoworkspace, 8"
          "$mainMod CTRL, 9, movetoworkspace, 9"
          "$mainMod CTRL, 0, movetoworkspace, 10"
          "$mainMod CTRL, TAB, movetoworkspace, special"

          # Move Windows
          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"
          # W/ Vim Controls
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"
        ];

        binde = [
          # Resize Windows
          "$mainMod CTRL, left, resizeactive, -1% 0%"
          "$mainMod CTRL, right, resizeactive, 1% 0%"
          "$mainMod CTRL, up, resizeactive, 0% 1%"
          "$mainMod CTRL, down, resizeactive, 0% -1%"
          # W/ Vim Controls
          "$mainMod CTRL, H, resizeactive, -1% 0%"
          "$mainMod CTRL, L, resizeactive, 1% 0%"
          "$mainMod CTRL, K, resizeactive, 0% 1%"
          "$mainMod CTRL, J, resizeactive, 0% -1%"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        misc = {
          disable_hyprland_logo = true;
          enable_swallow = true;
          swallow_regex = "^(kitty)$";
          # TODO: Make a bash script that lets me prevent window swallowing.
          # swallow_exception_regex = "^(spit)";
        };
      };
    };
  };
}
