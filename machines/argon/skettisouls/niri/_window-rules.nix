# Niri Window Rule Config
let
  # Match on all app-ids spawned at startup
  catchWindows = map (regex: { at-startup = true; app-id = regex; });
in
[
  # Startup windows don't take focus
  {
    open-focused = false;
    matches = [{ at-startup = true; }];
  }
  # Give windows rounded corners
  {
    clip-to-geometry = true;
    geometry-corner-radius = [ 6. 6. 6. 6. ];
  }
  # Open browsers on workspace 1 at startup
  {
    open-focused = true;
    open-maximized = true;
    open-on-workspace = "1-Browser";

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
    open-on-workspace = "2-Chat";

    matches = catchWindows [
      "(?i)discord"
      "(?i)vesktop"
      "(?i)dorion"
    ] ++ [{ at-startup = true; title = "(?i)discord"; }]; # Catch-all
  }
  {
    open-on-workspace = "3-Gaming";

    # Will match on proton games (appid is `steam_app_<ID>`),
    # but not native games (appid is set by the game itself).
    matches = [{ app-id = "^steam"; }];
    excludes = [{ app-id = "steam"; title = "^notificationtoasts_\\d+_desktop$"; }];
  }
  # Open audio software on workspace 4 at startup
  {
    open-on-workspace = "4-Audio";

    matches = catchWindows [
      "pulsemixer"
      ''com\.github\.wwmm\.easyeffects''
    ];
  }
  # Work around WezTerm's initial configure bug by setting an empty default-column-width
  {
    default-column-width = _: {};
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
    active-color = "#f38ba8";
    inactive-color = "#7d0d2d";
  in {
    shadow.color = inactive-color + "70";
    border = { inherit inactive-color; };
    focus-ring = { inherit active-color inactive-color; };
    tab-indicator = { inherit active-color inactive-color; };

    matches = [{ is-window-cast-target = true; }];
  })
  # Open RuneLite popups as floating windows
  {
    open-floating = true;
    matches = [{ app-id = "^net-runelite"; }];
  }
  # Open the RuneLite game window as a maximized tile
  # NOTE: Setting `Resize type` to `Keep window size`
  # is REQUIRED to prevent the sidebar going offscreen
  {
    open-floating = false;
    open-maximized = true;

    excludes = [{ title = "RuneLite Launcher"; }];
    matches = [{ app-id = "RuneLite$"; title = "RuneLite"; }];
  }
  # Open Steam maximized
  {
    open-floating = false;
    open-maximized = true;

    matches = [{ app-id = "steam"; title = "Steam"; }];
  }
  # Fix steam notification window position and focus
  {
    open-floating = true;
    open-focused = false;

    border.off = _: {};
    shadow.off = _: {};

    default-floating-position = _: {
      props = {
        x = 12;
        y = 12;
        relative-to = "bottom-right";
      };
    };

    matches = [{ app-id = "steam"; title = "^notificationtoasts_\\d+_desktop$"; }];
  }
  # Fix positioning and focus of keepassxc popup
  {
    open-floating = true;
    open-focused = true;

    # No way to make this work as of 26.04
    # See https://github.com/niri-wm/niri/issues/3420#issuecomment-3901330765
    default-floating-position = _: {
      props = {
        x = 1920 / 2;
        y = 1080 / 2;
        relative-to = "left";
      };
    };

    matches = [{
      app-id = "^org\.keepassxc\.KeePassXC$";
      title = "Unlock Database - KeePassXC";
    }];
  }
]
