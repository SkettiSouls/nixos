{
  imports = [
    ### Browser Modules ###
    ./browsers/default.nix
    ./browsers/brave.nix
    ./browsers/qutebrowser.nix

    ### Vesktop Modules ###
    ./vesktop/default.nix
    ./vesktop/vesktop.nix

    ### Fetch Modules ###
    ./fetch/default.nix
    ./fetch/neofetch.nix

    ### Loose Modules ###
    ./discord.nix
    ./kitty.nix
    ./mangohud.nix
  ];
}
