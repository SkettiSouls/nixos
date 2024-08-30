{
  # TODO: Move all configs here (most of hyprland module, bluetooth, etc)
  imports = [
    ./desktops/river.nix
    ./discord
    ./mangohud.nix
    ./terminals/kitty.nix
    ./udiskie.nix

    ### Audio ###
    ./audio/carla.nix
    ./audio/bluetooth.nix

    ### Browsers ###
    ./browsers/brave.nix
    ./browsers/qutebrowser.nix
    # ./browsers/schizofox.nix
  ];
}
