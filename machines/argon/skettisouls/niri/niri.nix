{ inputs, config, lib, withSystem, ... }:
let
  inherit (config.flake.machines.argon) system users;
  inherit (users.skettisouls) wrappers;

  inherit (withSystem system (a: a)) pkgs;
  inherit (inputs.wrapper-modules.lib) wrapPackage;

  # Share packages so that portable installs get deps and in-flake
  # installs get don't have to restart niri for dep config updates.
  packages = with pkgs; [
    # Wrappers
    wrappers.fuzzel
    wrappers.kitty
    wrappers.feishin

    # Startup
    unstable.brave
    unstable.discord
    easyeffects
    pulsemixer

    # Extra
    bluetuith # Might be replaced if I make a quickshell
    mpv
    nomacs
  ];

  wpaperd = wrapPackage {
    imports = [ config.flake.modules.wrappers.wpaperd ];
    config = {
      inherit pkgs;
      systemd.enable = true;
      settings.any.path = "${config.flake.root}/assets/purple-sun.jpg";
    };
  };

  # `_: {}` -> nothing
  niri = wrapPackage {
    imports = [ config.flake.modules.wrappers.niri ];
    config = {
      inherit pkgs;
      v2-settings = true;
      extraPackages = packages ++ [ wpaperd ];

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
    wrappers = {
      niri = niri.wrap ({ config, ... }: {
        buildCommand.systemd = {
          after = [ "symlinkScript" ];
          data = ''
            dir=${placeholder config.outputName}/share/systemd/user
            cp ${wpaperd.outPath}/share/systemd/user/*.service "$dir"/niri-wpaperd.service

            chmod +w "$dir"/niri.service
            cat >> "$dir"/niri.service<<EOF
            [Unit]
            Wants=niri-wpaperd.service
            EOF
          '';
        };
      });
    };
  };
}
