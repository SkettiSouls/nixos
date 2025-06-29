self@{ lib, ... }:
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (self.lib) listToAttrs';
  inherit (config.nixcord) vencord;

  # Discord's canary branch has a different binary name than package name
  discordClient =
    if lib.getName vencord.finalPackage == "discord-canary"
    then "discordcanary"
    else lib.getName vencord.finalPackage;

  defaultBrowser = config.xdg.browser.default;
  defaultHeadphones = config.basalt.headphones.default;
  cfg = config.basalt.desktops.niri;
in
{
  options.basalt.desktops.niri = {
    enable = mkEnableOption "Niri config";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ wezterm ];
    programs.niri.settings = {
      cursor.size = 24;
      gestures.hot-corners.enable = false;
      hotkey-overlay.hide-not-bound = true;
      prefer-no-csd = true;
      screenshot-path = "~/Pictures/niri-screenshots/%Y-%m-%d %H-%M-%S.png";

      outputs = {
        "HDMI-A-1" = {
          enable = true;
          position.x = 0;
          position.y = 0;

          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
        };
      };

      input = {
        mouse.accel-profile = "flat";
        keyboard = {
          numlock = true;
          repeat-delay = 300;
          repeat-rate = 50;
          xkb = {
            layout = "us";
            options = "ctrl:nocaps";
          };
        };
      };

      layout = {
        gaps = 10;
        focus-ring.enable = false;
        center-focused-column = "never";
        default-column-width.proportion = 0.5;

        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];

        border = {
          enable = true;
          width = 4;
          active.color = "#9522f0d8";
          inactive.color = "#505050";
          urgent.color = "#9b0000";
        };

        shadow = {
          enable = true;
          softness = 30;
          spread = 5;
          offset.x = 0;
          offset.y = 5;
          color = "#0007";
        };

        struts = {
          left = 6;
          right = 6;
          top = 6;
          bottom = 6;
        };
      };

      workspaces = {
        "01" = { name = "browser"; };
        "02" = { name = "chat"; };
        "03" = { name = "gaming"; };
        "04" = { name = "audio"; };
      };

      environment = {
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      };

      spawn-at-startup = [
        { command = [ "bash" "-c" ". <(niri completions bash)" ]; }
        { command = [ "${defaultBrowser}" ]; }
        { command = [ "${discordClient}" ]; }
        { command = [ "kitty" "--app-id" "pulsemixer" "pulsemixer" ]; }
        { command = [ "easyeffects" ]; }
      ];

      # Binds {{{
      binds = with config.lib.niri.actions; let
        sh = spawn "bash" "-c";

        bindWorkspaces = mod: action:
          listToAttrs'
            (map
            (i: { "${mod}+${toString i}".action.${action} = i; })
            (lib.range 1 9));
      in lib.mkMerge [
        (bindWorkspaces "Mod" "focus-workspace")
        (bindWorkspaces "Mod+Shift" "move-column-to-workspace")
        {
          "Mod+Shift+Return" = {
            action.spawn = "kitty";
            hotkey-overlay.title = "Open a terminal: kitty";
          };

          "Mod+D" = {
            action.spawn = "fuzzel";
            hotkey-overlay.title = "Open application runner: fuzzel";
          };

          "Mod+Escape" = {
            allow-inhibiting = false;
            action = toggle-keyboard-shortcuts-inhibit;
          };

          "Mod+Tab".action = focus-workspace-previous;
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+Space" = { repeat = false; action = toggle-overview; };

          "Mod+Ctrl+E".action      = quit;
          "Ctrl+Alt+Delete".action = quit;
          "Mod+Q".action           = close-window;
          "Mod+Shift+P".action     = power-off-monitors;

          # Screenshooting
          "Print".action           = screenshot { show-pointer = false; }; # Ctrl+C to copy, space to write
          "Ctrl+Print".action      = screenshot-window { write-to-disk = false; };
          "Shift+Print".action     = { screenshot-screen = { show-pointer = false; write-to-disk = false; }; };
          "Mod+Ctrl+Print".action  = screenshot-window;
          "Mod+Shift+Print".action = { screenshot-screen = { show-pointer = false; }; };

          # Screencasting
          "Mod+S".action       = set-dynamic-cast-monitor;
          "Mod+Shift+S".action = set-dynamic-cast-window;
          "Mod+Ctrl+S".action  = clear-dynamic-cast-target;

          "Mod+B" = {
            action = spawn "chp" defaultHeadphones;
            hotkey-overlay.title = "Connect headset: ${defaultHeadphones}";
          };

          "Mod+Alt+B" = {
            action = sh "bluetoothctl disconnect ${defaultHeadphones}";
            hotkey-overlay.title = "Disconnect headset: ${defaultHeadphones}";
          };

          "Mod+Shift+B".action = spawn defaultBrowser;
          "Mod+Shift+D".action = spawn discordClient;

          # Window management {{{
          # Options: *-column, *-window, *-workspace
          "Mod+Left".action  = focus-column-left;
          "Mod+Down".action  = focus-window-or-workspace-down;
          "Mod+Up".action    = focus-window-or-workspace-up;
          "Mod+Right".action = focus-column-right;
          "Mod+H".action     = focus-column-left;
          "Mod+J".action     = focus-window-or-workspace-down;
          "Mod+K".action     = focus-window-or-workspace-up;
          "Mod+L".action     = focus-column-right;

          "Mod+Shift+Left".action  = move-column-left;
          "Mod+Shift+Down".action  = move-window-down-or-to-workspace-down;
          "Mod+Shift+Up".action    = move-window-up-or-to-workspace-up;
          "Mod+Shift+Right".action = move-column-right;
          "Mod+Shift+H".action     = move-column-left;
          "Mod+Shift+J".action     = move-window-down-or-to-workspace-down;
          "Mod+Shift+K".action     = move-window-up-or-to-workspace-up;
          "Mod+Shift+L".action     = move-column-right;

          "Mod+Ctrl+Left".action  = focus-monitor-left;
          "Mod+Ctrl+Down".action  = focus-monitor-down;
          "Mod+Ctrl+Up".action    = focus-monitor-up;
          "Mod+Ctrl+Right".action = focus-monitor-right;
          "Mod+Ctrl+H".action     = focus-monitor-left;
          "Mod+Ctrl+J".action     = focus-monitor-down;
          "Mod+Ctrl+K".action     = focus-monitor-up;
          "Mod+Ctrl+L".action     = focus-monitor-right;

          "Mod+Shift+Ctrl+Left".action  = move-column-to-monitor-left;
          "Mod+Shift+Ctrl+Down".action  = move-column-to-monitor-down;
          "Mod+Shift+Ctrl+Up".action    = move-column-to-monitor-up;
          "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
          "Mod+Shift+Ctrl+H".action     = move-column-to-monitor-left;
          "Mod+Shift+Ctrl+J".action     = move-column-to-monitor-down;
          "Mod+Shift+Ctrl+K".action     = move-column-to-monitor-up;
          "Mod+Shift+Ctrl+L".action     = move-column-to-monitor-right;

          "Mod+U".action = focus-column-first;
          "Mod+I".action = focus-column-last;
          "Mod+Shift+U".action = move-column-to-first;
          "Mod+Shift+I".action = move-column-to-last;

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;
          "Mod+BracketLeft".action = consume-or-expel-window-left;
          "Mod+BracketRight".action = consume-or-expel-window-right;

          "Mod+C".action = center-column;
          "Mod+Shift+C".action = center-window;
          "Mod+Ctrl+C".action = center-visible-columns;

          "Mod+W".action = toggle-column-tabbed-display;
          "Mod+V".action = toggle-window-floating;
          "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = switch-preset-window-height;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+Ctrl+F".action = reset-window-height;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%"; # }}}
        } # }}}
      ];

      # Window rules {{{
      window-rules = let
        unifyCorners = radius: {
          bottom-left = radius;
          bottom-right = radius;
          top-left = radius;
          top-right = radius;
        };

        # Match on all app-ids spawned at startup
        catchWindows = map (regex: { at-startup = true; app-id = regex; });
      in [
        # Startup windows don't take focus
        {
          open-focused = false;
          matches = [{ at-startup = true; }];
        }
        # Give windows rounded corners
        {
          clip-to-geometry = true;
          geometry-corner-radius = unifyCorners 6.;
        }
        # Open browsers on workspace 1 at startup
        {
          open-maximized = true;
          open-on-workspace = "browser";

          matches = catchWindows [
            "(?i)nyxt"
            "(?i)brave"
            "(?i)luakit"
            "(?i)firefox"
            ''org\.qutebrowser\.qutebrowser''
          ];
        }
        # Open discord clients on workspace 2 at startup
        {
          open-maximized = true;
          open-on-workspace = "chat";

          matches = catchWindows [
            "(?i)discord"
            "(?i)vesktop"
            "(?i)dorion"
          ] ++ [{ at-startup = true; title = "(?i)discord"; }]; # Catch-all
        }
        # Open audio software on workspace 4 at startup
        {
          open-on-workspace = "audio";

          matches = catchWindows [
            "pulsemixer"
            ''com\.github\.wwmm\.easyeffects''
          ];
        }
        # Work around WezTerm's initial configure bug by setting an empty default-column-width
        {
          default-column-width = {};
          matches = [{ app-id = "^org\.wezfurlong\.wezterm$"; }];
        }
        # Open the Firefox picture-in-picture player as floating by default
        {
          open-floating = true;
          matches = [{ app-id = "firefox"; title = "Picture-in-Picture"; }];
        }
        # Black out sensitive windows when screencasting
        {
          block-out-from = "screen-capture";

          matches = [
            { app-id = "^org\.keepassxc\.KeePassXC$"; }
            { app-id = "^org\.gnome\.World\.Secrets$"; }
          ];
        }
        # Draw a red border around captured windows
        (let
          activeColor = "#f38ba8";
          inactiveColor = "#7d0d2d";
        in {
          shadow.color = inactiveColor + "70";
          border.inactive.color = inactiveColor;

          focus-ring = {
            active.color = activeColor;
            inactive.color = inactiveColor;
          };

          tab-indicator = {
            active.color = activeColor;
            inactive.color = inactiveColor;
          };

          matches = [{ is-window-cast-target = true; }];
        })
      ]; # }}}
    };
  };
}
