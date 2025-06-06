{ inputs, ... }:
{ config, ... }:
let
  inherit (config.flake) networks roles wrappers;
  inherit (inputs.neovim.packages.${system}) neovim;

  system = "x86_64-linux";
  wpkgs = wrappers.${system};
in
{
  flake.machines.fluorine = {
    inherit system;
    roles = with roles; [ workstation ];
    networks = with networks; [ peridot ];

    users.skettisouls = {
      packages = with wpkgs.skettisouls; [
        eza
        neovim
      ];
    };

    modules = [
      ./configuration.nix
      ./hardware-configuration.nix
      ./services.nix
    ];
  };
}
