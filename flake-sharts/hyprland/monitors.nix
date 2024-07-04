{ self, config, lib, ... }:
let
  inherit (self.lib)
    listToAttrs'
    ;

  inherit (lib)
    mkOption
    types
    ;

  inherit (builtins)
    toString
    ;

  cfg = config.shit.hardware.monitors;
  mon = listToAttrs' ([ cfg.defaultMonitor ] ++ cfg.monitors);

  bitdepth = if mon.bitdepth != 8 then ",bitdepth,10" else "";
  mirror = if mon.mirror != null then ",mirror,${mon.mirror}" else "";
  position = if mon.position == "automatic" then "auto" else mon.position;
  resolution = if mon.resolution == "maxrefreshrate" then "highrr"
    else if mon.resolution == "maxresolution" then "highres"
    else if mon.resolution == "preffered" then mon.resolution
    else if mon.refreshRate != null then "${mon.resolution}@${toString mon.refreshRate}"
    else ""
    ;

  rotation = let add = if mon.flipped then 4 else 0; mr = mon.rotation; in (
    if mr == 0 then (toString (add + 0))
    else if mr == 90 then (toString (add + 1))
    else if mr == 180 then (toString (add + 2))
    else if mr == 270 then (toString (add + 3))
    else "0"
  );
in
{
  options.shit.hardware.monitors = {
    monitors = mkOption {
      type = with types; listOf attrs;
      default = [{ /* This option shares a value with the nixos `monitors` option */ }];
    };

    defaultMonitor = mkOption {
      description = ''Set options for all monitors plugged in but not configured.'';
      type = types.attrs;
      default = {
        resolution = "preffered";
        position = "automatic";
      };
    };
  };

  config = {
    wayland.windowManager.hyprland.settings = {
      monitor = if mon.disable then "${mon.displayPort},disable" else
        "${mon.displayPort},${resolution},${position},${toString mon.scale},transform,${rotation}${mirror}${bitdepth}"
        ;

      workspace = if mon.disable then []
        else map (ws:
          "${toString ws},monitor:${mon.displayPort},default:${if ws == mon.defaultWorkspace then "true" else "false"}"
        ) mon.workspaces
        ;

      exec-once = [ (let mon = lib.findSingle (x: x.primary) false false cfg.monitors; in if mon != false then "xrandr --output ${mon.displayPort} --primary" else "") ];
    };
  };
}
