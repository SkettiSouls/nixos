{ inputs, config, lib, withSystem, ... }:
let
  inherit (config.flake.machines.argon) system users;
  inherit (users.skettisouls) wrappers;

  inherit (withSystem system (a: a)) pkgs;
  inherit (inputs.wrapper-modules.lib) wrapPackage wrapperModules;


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
    imports = [ wrapperModules.niri ];

    config = {
      inherit pkgs;
      v2-settings = true;
      runtimePkgs = with pkgs; packages ++ [
        wpaperd
        xwayland-satellite
      ];

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
          "keepassxc"
          "brave"
          "discord"
          "steam"
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
      niri = niri.wrap {
        constructFiles.portalConfig = {
          relPath = "share/xdg-desktop-portal/niri-portals.conf";
          content = ''
            [preferred]
            default=gnome;gtk;
            org.freedesktop.impl.portal.Access=gtk;
            org.freedesktop.impl.portal.Notification=gtk;
            org.freedesktop.impl.portal.FileChooser=gtk;
            org.freedesktop.impl.portal.ScreenCast=gnome;
          '';
        };

        buildCommand.systemd = {
          after = [ "symlinkScript" ];
          data = ''
            services="$out"/share/systemd/user

            cp ${wpaperd.outPath}/share/systemd/user/*.service "$services"/niri-wpaperd.service

            chmod +w "$services"/niri.service
            cat >> "$services"/niri.service<<EOF
            [Unit]
            Wants=niri-wpaperd.service
            EOF
          '';
        };
      };
    };
  };
}
