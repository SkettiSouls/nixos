self@{ lib, ... }:
{ config, lib, ... }:
let
  inherit (self.lib)
    exponent
    listToAttrs'
    ;

  inherit (lib)
    elem
    mapAttrs
    mkDefault
    mkIf
    mkMerge
    ;

  inherit (cfg.variables)
    modKey
    appMod
    specialMod
    terminal
    ;

  inherit (config.wayland.windowManager.river.settings) declare-mode;

  sharedBinds = {
    # Eject the optical drive (if you still have one lmfao)
    "None XF86Eject" = "spawn 'eject -T'";

    # Control pulse audio volume with pamixer
    "None XF86AudioRaiseVolume" = "spawn 'pamixer -i 5'";
    "None XF86AudioLowerVolume" = "spawn 'pamixer -d 5'";
    "None XF86AudioMute" = "spawn 'pamixer --toggle-mute'";

    # Control MPRIS aware media players with playerctl
    "None XF86AudioMedia" = "spawn 'playerctl play-pause'";
    "None XF86AudioPlay" = "spawn 'playerctl play-pause'";
    "None XF86AudioPrev" = "spawn 'playerctl previous'";
    "None XF86AudioNext" = "spawn 'playerctl next'";

    # Control screen backlight brightness with brightnessctl
    "None XF86MonBrightnessUp" = "spawn 'brightnessctl set +5%'";
    "None XF86MonBrightnessDown" = "spawn 'brightnessctl set 5%-'";
  };

  mkTag = tag: toString (exponent 2 (tag - 1));
  allTags = toString ((exponent 2 32) - 1);
  bindTags = key: cmd: listToAttrs' (map (tag: { "${key} ${toString tag}" = "${cmd} ${mkTag tag}"; }) cfg.tags);

  mkAllDefault = set: mapAttrs (_: v: mkDefault v) set;

  cfg = config.regolith.river;
in
{
  config.wayland.windowManager.river = mkIf cfg.enable {
    settings = {
      map = lib.mkMerge [ cfg.bind.keys {
        locked = mkIf (elem "locked" declare-mode) (mkAllDefault sharedBinds);
        normal = mkIf (elem "normal" declare-mode) (mkAllDefault (sharedBinds // {
          "${modKey} Return" = "zoom"; # Bump focused view to the top of the layout stack
          "${modKey} Q" = "close"; # Close focused view
          "${modKey} J" = "focus-view next";
          "${modKey} K" = "focus-view previous";
          "${modKey} Period" = "focus-output next";
          "${modKey} Comma" = "focus-output previous";
          "${modKey} Space" = "toggle-float";
          "${modKey} F" = "toggle-fullscreen";
          "${modKey} 0" = "set-focused-tags ${allTags}";

          "${appMod} Return" = "spawn ${terminal}";
          "${appMod} E" = "exit";
          "${appMod} J" = "swap next";
          "${appMod} K" = "swap previous";
          "${appMod} Period" = "send-to-output next";
          "${appMod} Comma" = "send-to-output previous";
          "${appMod} 0" = "set-view-tags ${allTags}";

        # Floating Mode {{{
          # Move views
          "${modKey}+Alt H" = "move left 100";
          "${modKey}+Alt J" = "move down 100";
          "${modKey}+Alt K" = "move up 100";
          "${modKey}+Alt L" = "move right 100";

          # Snap views to screen edges
          "${appMod}+Alt H" = "resize horizontal -100";
          "${appMod}+Alt J" = "resize vertical 100";
          "${appMod}+Alt K" = "resize vertical -100";
          "${appMod}+Alt L" = "resize horizontal 100";

          # Resize views
          "${specialMod}+Alt H" = "snap left";
          "${specialMod}+Alt J" = "snap down";
          "${specialMod}+Alt K" = "snap up";
          "${specialMod}+Alt L" = "snap right"; # }}}
        } // bindTags "${modKey}" "set-focused-tags"
          // bindTags "${appMod}" "set-view-tags"
          // bindTags "${specialMod}" "toggle-focused-tags"
          // bindTags "${specialMod}+Shift" "toggle-view-tags"
        ));
      }
      (mkIf cfg.passthrough.enable {
        normal = mkIf (elem "normal" declare-mode) {
          "${modKey} ${cfg.passthrough.keybind}" = mkDefault "enter-mode passthrough";
        };

        passthrough = mkIf (elem "normal" declare-mode) {
          "${modKey} ${cfg.passthrough.keybind}" = mkDefault "enter-mode normal";
        };
      })];

      map-pointer = mkMerge [ cfg.bind.mouse {
        normal = mkIf (elem "normal" declare-mode) (mkAllDefault {
          "${modKey} BTN_LEFT" = "move-view";
          "${modKey} BTN_RIGHT" = "resize-view";
          "${modKey} BTN_MIDDLE" = "toggle-float";
        });
      }];

      map-switch = cfg.bind.switch;
      unmap = cfg.unbind.keys;
      unmap-pointer = cfg.unbind.mouse;
      unmap-switch = cfg.unbind.switch;
    };
  };
}
