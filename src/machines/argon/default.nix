{ withArgs, ... }:
{ config, ... }:
let
  inherit (config.flake)
    hardwareModules
    networks
    roles
    wrappers
    ;
in
{
  flake.machines.argon = let
    system = "x86_64-linux";
    wpkgs = wrappers.${system};
  in {
    inherit system;
    hardware = with hardwareModules; [ gpu.amd bluetooth ];
    roles = with roles; [ desktop gaming workstation ];
    networks = with networks; [ peridot ];

    users = {
      skettisouls = {
        homeModule = withArgs ./skettisouls {};
        packages = with wpkgs.skettisouls; [
          eza
          feishin
          nushell
        ];
      };
    };

    modules = [
      ./configuration.nix
      ./hardware-configuration.nix
    ];
  };
}
