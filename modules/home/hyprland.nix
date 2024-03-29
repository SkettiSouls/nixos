{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    specialArgs
    ;

  cfg = config.shit.hyprland;
in
{
  options.shit.hyprland = {
    enable = mkEnableOption "Hyprland user config";
  };


  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      slurp
      (grimblast.override {
        # Change hyprpicker dependency version to v0.1.1 to prevent core dumps.
        hyprpicker = pkgs.hyprpicker.overrideAttrs (oldAttrs: {
          version = "0.1.1";

          src = oldAttrs.src.overrideAttrs {
            outputHash = "sha256-k+rG5AZjz47Q6bpVcTK7r4s7Avg3O+1iw+skK+cn0rk";
          };
        });
      })
      wl-clipboard
      unstable.hyprpaper
      dunst
    ];

    shit.xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    home.file.".config/hypr/hyprpaper.conf".text = ''
      preload = ${config.home.homeDirectory}/Pictures/Wallpapers/oswp.png
      preload = ${config.home.homeDirectory}/Pictures/Wallpapers/suncat.jpg
      # wallpaper = HDMI-A-1,contain:${config.home.homeDirectory}/Pictures/Wallpapers/oswp.jpg
      wallpaper = HDMI-A-1,contain:${config.home.homeDirectory}/Pictures/Wallpapers/suncat.jpg
      splash = false
    '';

    wayland.windowManager.hyprland = {
      enable = true;
      #package = pkgs.hyprland-src;
      #package = pkgs.unstable.hyprland;
      xwayland.enable = true;
      settings = {
        # Monitor layouts, see https://wiki.hyprland.org/Configuring/Monitors/
        "monitor" = "HDMI-A-1,1920x1080@60,0x0,1";

        exec-once = [
          "hyprpaper &"
          "dunst &"
          "polkit &"
          "bluetoothctl connect E8:EE:CC:4B:FA:2A"
          "[workspace 10 silent] carla /etc/nixos/shit/carla/system.carxp"
          "[workspace 1 silent] qutebrowser"
          "[workspace 2 silent] vesktop"
          "[workspace 3 silent] steam"
        ];

        "env" = "XCURSOR_SIZE,24";

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
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";
        };

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/
          rounding = 10;

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
          preserve_split = "yes"; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/
          new_is_master = true;
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/
          workspace_swipe = "off";
        };

        # Custom Variables
        "$mainMod" = "SUPER";
        "$TERM" = "kitty";

        bind = [
          # System Binds
          "$mainMod, Q, killactive"
          #"$mainMod, E, wlogout -p layer-shell"
          "$mainMod, S, togglefloating"
          #"$mainMod, R, exec, wofi --show drun"
          #"$mainMod ALT, R, exec, update-desktop-database"
          "$mainMod, P, pseudo"
          "$mainMod, V, togglesplit"
          "$mainMod, F, fullscreen"
          "$mainMod, RETURN, exec, $TERM"
          ''$mainMod, ESCAPE, exec, $TERM sh -c "sudo nixos-rebuild switch; hyprctl reload; echo; echo 'Press enter to exit'; read"''
          "$mainMod, B, exec, bluetoothctl power on && bluetoothctl connect E8:EE:CC:4B:FA:2A"
          "$mainMod ALT, B, exec, bluetoothctl disconnect"
          "$mainMod, C, exec, $TERM -e nvim /etc/nixos/modules/home/hyprland.nix"

          # App Binds (SUPER_SHIFT)
          "$mainMod SHIFT, E, exec, nemo"
          "$mainMod SHIFT, B, exec, ${config.shit.browsers.default}"
          #"$mainMod SHIFT, B, exec, brave"
          #"$mainMod SHIFT, B, exec, firefox"
          "$mainMod SHIFT, D, exec, [workspace 2 silent] vesktop"
          "$mainMod SHIFT, S, exec, [workspace 3 silent] steam"

          # Grimblast Screenshot && Copy
          ", PRINT, exec, grimblast -f copy output"
          " SHIFT, PRINT, exec, grimblast -f copy area"
          " CTRL, PRINT, exec, grimblast -f copy screen"

          # Grimblast Screenshot && CopySave
          "$mainMod, PRINT, exec, grimblast -f copy output && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png"
          "$mainMod SHIFT, PRINT, exec, grimblast -f copy area && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png"
          "$mainMod CTRL, PRINT, exec, grimblast -f copy screen && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png"

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

          # Move/Resize Windows
          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"
          "$mainMod CTRL, left, resizeactive, -1% 0%"
          "$mainMod CTRL, right, resizeactive, 1% 0%"
          "$mainMod CTRL, up, resizeactive, 0% 1%"
          "$mainMod CTRL, down, resizeactive, 0% -1%"
          # W/ Vim Controls
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"
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
          #swallow_exception_regex = "^(spit)"; # anti-swallow bash script planned
        };
      };

    };
  };
}
