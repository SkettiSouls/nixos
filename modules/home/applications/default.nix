{
  imports = [
    ### Browser Modules ###
    ./browsers/default.nix

    ### Vesktop Modules ###
    ./vesktop/default.nix
    ./vesktop/vesktop.nix

    ### Fetch Modules ###
    ./fetch/default.nix
    ./fetch/neofetch.nix

    ### Loose Modules ###
    ./defaults.nix
    ./discord.nix
    ./kitty.nix
    ./mangohud.nix
  ];
}
