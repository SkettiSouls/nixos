{
  imports = [
    ### Browser Modules ###
    ./browsers/default.nix
    ./browsers/brave.nix
    ./browsers/qutebrowser.nix

    ### Vesktop Modules ###
    ./vesktop/default.nix
    ./vesktop/vesktop.nix

    ### Loose Modules ###
    ./discord.nix
    ./kitty.nix
    ./mangohud.nix
    ./neofetch.nix
  ];
}
