# TODO 6: set wallpaper
{ inputs, config, lib, withSystem, ... }:
let
  inherit (config.flake.machines.argon) system users;
  inherit (users.skettisouls) wrappers;

  inherit (withSystem system (a: a)) pkgs;

  # Share packages so that portable installs get deps and in-flake
  # installs get don't have to restart niri for dep config updates.
  packages = with pkgs; [
    wrappers.fuzzel
    wrappers.kitty
    wrappers.feishin

    unstable.brave
    unstable.discord
    easyeffects
    pulsemixer
  ];

  # `_: {}` -> nothing
  niri = inputs.wrapper-modules.lib.wrapPackage {
    imports = [ config.flake.modules.wrappers.niri ];
    config = {
      inherit pkgs;
      v2-settings = true;
      extraPackages = packages;

      settings = {
        prefer-no-csd = _: {};
        gestures.hot-corners.off = _: {};
        hotkey-overlay.hide-not-bound = _: {};
        screenshot-path = "~/Pictures/niri-screenshots/%Y-%m-%d %H-M-%S.png";

        binds = import ./_binds.nix { inherit config lib pkgs; };
        layout = import ./_layout.nix;
        window-rules = import ./_window-rules.nix;

        environment = {
          "ELECTRON_OZONE_PLATFORM_HINT" = "wayland";
        };

        input = {
          keyboard = {
            xkb = {
              layout = "us";
              options = "ctrl:nocaps";
            };
            repeat-delay = 300;
            repeat-rate = 50;
            track-layout = "global";
            numlock = _: {};
          };

          touchpad.off = _: {};
          mouse.accel-profile = "flat";
        };

        outputs."HDMI-A-1" = {
          transform = "normal";
          mode = "1920x1080@60.000000";
          position = _: {
            props.x = 0;
            props.y = 0;
          };
        };

        workspaces = {
          "1-Browser" = _: {};
          "2-Chat" = _: {};
          "3-Gaming" = _: {};
          "4-Audio" = _: {};
        };

        spawn-at-startup = [
          [ "bash" "-c" ". <(niri completions bash)" ]
          "brave"
          "discord"
          [ "kitty" "--app-id" "pulsemixer" "pulsemixer" ]
          "easyeffects"
        ];
      };
    };
  };
in {
  flake.machines.argon.users.skettisouls = {
    inherit packages;
    wrappers = { inherit niri; };
  };
}
