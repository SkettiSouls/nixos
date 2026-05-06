{ inputs, config, lib, withSystem, ... }:
let
  inherit (inputs.wrapper-modules.lib) evalModule;
  inherit (config.flake.machines.argon) system users;
  inherit (users.skettisouls) wrappers;

  # `_: {}` -> nothing
  wrapper = evalModule (
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.niri ];
      config = {
        extraPackages = [
          wrappers.fuzzel
          wrappers.kitty
        ];

        v2-settings = true;
        settings = {
          prefer-no-csd = _: {};
          gestures.hot-corners.off = _: {};
          hotkey-overlay.hide-not-bound = _: {};
          screenshot-path = "~/Pictures/niri-screenshots/%Y-%m-%d %H-M-%S.png";

          binds = import ./_binds.nix { inherit config lib; };
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
        };
      };
    });

  niri = withSystem system ({ pkgs, ... }: wrapper.config.wrap { inherit pkgs; });
in {
  flake.machines.argon.users.skettisouls.wrappers = { inherit niri; };
}
