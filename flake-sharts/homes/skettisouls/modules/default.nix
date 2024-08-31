{
  imports = [
    ./discord
    ./mangohud.nix
    ./udiskie.nix

    ### Audio ###
    ./audio/bluetooth.nix
    ./audio/carla.nix
    ./audio/mpv.nix

    ### Browsers ###
    ./browsers/brave.nix
    ./browsers/qutebrowser.nix
    # ./browsers/schizofox.nix

    ### Desktops ###
    # TODO: Move hyprland here
    ./desktops/river.nix

    ### Terminals ###
    ./terminals/kitty.nix

    ### Tools ###
    ./tools/bash.nix
    ./tools/gpg.nix
  ];
}
