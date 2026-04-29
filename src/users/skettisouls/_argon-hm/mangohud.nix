{ ... }:
{ pkgs, ... }:

{
  config = {
    # TODO: Figure out how to set the order options are generated in
    programs.mangohud.enable = true;

    # Workaround, see todo above
    xdg.configFile."MangoHud/MangoHud.conf".text = ''
      ### PERFORMANCE ###
      fps_limit=0
      # vsync=1 # Breaks certain apps??

      ### ELEMENTS ###
      cpu_stats
      cpu_temp
      gpu_stats
      gpu_temp
      ram
      vram
      fps
      engine_short_names # Required to get engine names in horizontal
      frame_timing
      # engine_version
      # vulkan_driver
      display_server
      wine

      # time
      # time_no_label
      # time_format=%r # %r for 12 hour, %T for 24 hour

      ### WINDOW ###
      legacy_layout=0
      horizontal
      hud_no_margin
      horizontal_stretch
      background_alpha=0.7

      ### KEYBINDS ###
      toggle_hud=Shift_R+F12
    '';
  };
}
