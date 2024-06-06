{ inputs, ... }:

{
  imports = [
    inputs.schizofox.homeManagerModule

    ./brave.nix
    ./qutebrowser.nix
    ./schizofox.nix
    ./tridactyl.nix
  ];
}
