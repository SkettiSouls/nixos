{
  # TODO: Move all configs here (most of hyprland module, bluetooth, etc)
  imports = [
    ./audio/carla.nix
    ./desktops/river.nix
    ./discord
    ./terminals/kitty.nix

    ### Browsers ###
    ./browsers/brave.nix
    ./browsers/qutebrowser.nix
    # ./browsers/schizofox.nix
  ];
}
