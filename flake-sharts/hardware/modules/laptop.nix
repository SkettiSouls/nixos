{ self, config, lib, pkgs, ... }:
let
  inherit (self.lib)
    listToAttrs'
    ;

  inherit (lib)
    mkEnableOption
    mkIf
    ;

  laptop = config.shit.hardware.laptop;

  monitors = listToAttrs' config.shit.hardware.monitors;
  internalMonitor = if monitors.primary then monitors.displayPort else "";
  lidSwitch = monitors.lidSwitch;
in
{
  options.shit.hardware.laptop = mkEnableOption "Set device as a laptop";

  config = mkIf laptop {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];

    home-manager.sharedModules = [{
      # Set hardware specifics (i.e. fn keys, closing/opening events)
      wayland.windowManager.hyprland.settings = {
        # TODO: Make close suspend and open wake up. (saves power)
        # Turn monitor off and on when closing and opening the lid respectively.
        bindl = [
          '', XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'' # FN + F5
        ] ++ (if (lidSwitch != "") then [
          # ",switch:${lidSwitch},exec,hyprlock" # Toggle
          '',switch:on:${lidSwitch},exec,hyprctl keyword monitor "${internalMonitor}, disable"'' # Close
          '',switch:${lidSwitch},exec,hyprctl keyword monitor "${internalMonitor}, ${monitors.resolution}, ${monitors.position}, ${builtins.toString monitors.scale}"'' # Open
        ] else []);

        bindel = [
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" # FN + F6
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" # FN + F7
        ];

        bind = [
          ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ];
      };
    }];
  };
}
