{ ... }:
{ config, ... }:
let
  inherit (config.flake) networks roles wrappers;
in
{
  flake.machines.fluorine = let
    system = "x86_64-linux";
    wpkgs = wrappers.${system};
  in {
    inherit system;
    roles = with roles; [ workstation ];
    networks = with networks; [ peridot ];

    users.skettisouls = {
      packages = with wpkgs.skettisouls; [
        eza
      ];
    };

    modules = [
      ./configuration.nix
      ./hardware-configuration.nix
      ./services.nix
    ];
  };
}
