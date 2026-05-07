# Niri Keybind Config
{ config, lib, pkgs, ... }:
let
  inherit (config.flake.lib) listToAttrs';

  muteOSD = "${pkgs.regolith.quickshell-mute-osd}/bin/quickshell-mute-osd";
  toggleMic = pkgs.writeShellScript "mic-toggle.sh" ''
    if "$(${muteOSD} --check)"; then
      ${muteOSD} --die
      wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
    else
      ${muteOSD} &
      wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
    fi
  '';

  bindWorkspaces = mod: action:
    listToAttrs'
      (map
      (i: { "${mod}+${toString i}".${action} = i; })
      (lib.range 1 9));

    bindActions = attr:
      lib.mapAttrs
      (_: v:
        if lib.isString v
        then { "${v}" = _: {}; }
        else v)
      attr;
in lib.mkMerge [
  (bindWorkspaces "Mod" "focus-workspace")
  (bindWorkspaces "Mod+Shift" "move-column-to-workspace")
  {
    # Spawners
    "Mod+Shift+Return" = _: {
      content.spawn = "kitty";
      props.hotkey-overlay-title = "Open a terminal: kitty";
    };

    "Mod+D" = _: {
      content.spawn = "fuzzel";
      props.hotkey-overlay-title = "Open application runner: fuzzel";
    };

    "Mod+Escape" = _: {
      content.toggle-keyboard-shortcuts-inhibit = _: {};
      props.allow-inhibiting = false;
    };

    "Mod+Space" = _: {
      content.toggle-overview = _: {};
      props.repeat = false;
    };

    "Mod+MouseBack" = _: {
      content.spawn = "${toggleMic}";
      props.hotkey-overlay-title = "Mute/unmute microphone";
    };

    "Mod+B" = _: {
      content.spawn = [ "chp" "80:C3:BA:3F:EB:B9" ];
      props.hotkey-overlay-title = "Connect headset: Momentum 4";
    };

    "Mod+Alt+B" = _: {
      content.spawn-sh = "bluetootctl disconnect 80:C3:BA:3F:EB:B9";
      props.hotkey-overlay-title = "Disconnect headset: Momentum 4";
    };

    # TODO: get default browser
    "Mod+Shift+B".spawn = "brave";
    "Mod+Shift+D".spawn = "discord";
  }
  {
    # Screenshooting
    "Print".screenshot = _: { props.show-pointer = false; };
    "Ctrl+Print".screenshot-window = _: { props.write-to-disk = false; };
    "Shift+Print".screenshot-screen = _: {
      props.show-pointer = false;
      props.write-to-disk = false;
    };

    "Mod+Ctrl+Print".screenshot-window = _: { props.write-to-disk = true; };
    "Mod+Shift+Print".screenshot-screen = _: {
      props.write-to-disk = true;
      props.show-pointer = false;
    };
  }
  (bindActions {
    "Mod+Tab"          = "focus-workspace-previous";
    "Mod+Shift+Slash"  = "show-hotkey-overlay";

    "Mod+Ctrl+E"       = "quit";
    "Ctrl+Alt+Delete"  = "quit";
    "Mod+Q"            = "close-window";
    "Mod+Shift+P"      = "power-off-monitors"; # TODO: Toggle on/off

    # Screencasting
    "Mod+S"            = "set-dynamic-cast-monitor";
    "Mod+Shift+S"      = "set-dynamic-cast-window";
    "Mod+Ctrl+S"       = "clear-dynamic-cast-target";

    # Window management {{{
    # Movement {{{
    "Mod+Left"         = "focus-column-left";
    "Mod+Down"         = "focus-window-or-workspace-down";
    "Mod+Up"           = "focus-window-or-workspace-up";
    "Mod+Right"        = "focus-column-right";
    "Mod+H"            = "focus-column-left";
    "Mod+J"            = "focus-window-or-workspace-down";
    "Mod+K"            = "focus-window-or-workspace-up";
    "Mod+L"            = "focus-column-right";

    "Mod+Shift+Left"   = "move-column-left";
    "Mod+Shift+Down"   = "move-window-down-or-to-workspace-down";
    "Mod+Shift+Up"     = "move-window-up-or-to-workspace-up";
    "Mod+Shift+Right"  = "move-column-right";
    "Mod+Shift+H"      = "move-column-left";
    "Mod+Shift+J"      = "move-window-down-or-to-workspace-down";
    "Mod+Shift+K"      = "move-window-up-or-to-workspace-up";
    "Mod+Shift+L"      = "move-column-right";

    "Mod+Ctrl+Left"    = "focus-monitor-left";
    "Mod+Ctrl+Down"    = "focus-monitor-down";
    "Mod+Ctrl+Up"      = "focus-monitor-up";
    "Mod+Ctrl+Right"   = "focus-monitor-right";
    "Mod+Ctrl+H"       = "focus-monitor-left";
    "Mod+Ctrl+J"       = "focus-monitor-down";
    "Mod+Ctrl+K"       = "focus-monitor-up";
    "Mod+Ctrl+L"       = "focus-monitor-right";

    "Mod+Shift+Ctrl+Left"  = "move-column-to-monitor-left";
    "Mod+Shift+Ctrl+Down"  = "move-column-to-monitor-down";
    "Mod+Shift+Ctrl+Up"    = "move-column-to-monitor-up";
    "Mod+Shift+Ctrl+Right" = "move-column-to-monitor-right";
    "Mod+Shift+Ctrl+H"     = "move-column-to-monitor-left";
    "Mod+Shift+Ctrl+J"     = "move-column-to-monitor-down";
    "Mod+Shift+Ctrl+K"     = "move-column-to-monitor-up";
    "Mod+Shift+Ctrl+L"     = "move-column-to-monitor-right"; # }}}

    "Mod+U"            = "focus-column-first";
    "Mod+I"            = "focus-column-last";
    "Mod+Shift+U"      = "move-column-to-first";
    "Mod+Shift+I"      = "move-column-to-last";

    "Mod+Comma"        = "consume-window-into-column";
    "Mod+Period"       = "expel-window-from-column";
    "Mod+BracketLeft"  = "consume-or-expel-window-left";
    "Mod+BracketRight" = "consume-or-expel-window-right";

    "Mod+C"            = "center-column";
    "Mod+Shift+C"      = "center-window";
    "Mod+Ctrl+C"       = "center-visible-columns";

    "Mod+W"            = "toggle-column-tabbed-display";
    "Mod+V"            = "toggle-window-floating";
    "Mod+Shift+V"      = "switch-focus-between-floating-and-tiling";

    "Mod+R"            = "switch-preset-column-width";
    "Mod+Shift+R"      = "switch-preset-window-height";
    "Mod+F"            = "maximize-column";
    "Mod+Shift+F"      = "fullscreen-window";
    "Mod+Ctrl+F"       = "reset-window-height";

    "Mod+Minus".set-column-width        = "-10%";
    "Mod+Equal".set-column-width        = "+10%";
    "Mod+Shift+Minus".set-window-height = "-10%";
    "Mod+Shift+Equal".set-window-height = "+10%"; # }}}
  })
]
