{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.mangohud;
in
{
  options.shit.mangohud = {
    enable = mkEnableOption "MangoHud user configuration";
  };

  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
    };

    # Unsure how to set the order in which options are generated in MangoHud.conf using 'programs.mangohud'.
    home.file.".config/MangoHud/MangoHud.conf".text = ''
       /* PERFORMANCE */
       fps_limit=0
       #vsync=1

       /* ELEMENTS */
       cpu_stats
       cpu_temp
       gpu_stats
       gpu_temp
       ram
       vram
       fps
       frametime
       frame_timing
       gamemode

       /* WINDOW */
       legacy_layout=0
       #horizontal_stretch
       position=top-left
       round_corners=10
       #offset_x=0
       #offset_y=0
       #width=0
       #height=140
       alpha=1.000000
       background_alpha=0.500000

      /* KEYBINDS */
      toggle_hud=F11
    '';
  };
}
