{ inputs, withArgs, ... }:
{ config, ... }:
let
  inherit (config.flake)
    hardwareModules
    networks
    roles
    wrappers
    ;

  system = "x86_64-linux";
  wpkgs = wrappers.${system};
  chaotic = inputs.nyxpkgs.nixosModules;
in
{
  flake.machines.argon = {
    inherit system;
    hardware = with hardwareModules; [ bluetooth gpu.amd usb ];
    roles = with roles; [ desktop gaming workstation ];
    networks = with networks; [ peridot ];

    users = {
      skettisouls = {
        homeModule = withArgs ./skettisouls {};
        packages = with wpkgs.skettisouls; [
          eza
          feishin
          nushell
          lazygit
        ];
      };
    };

    modules = [
      chaotic.nyx-cache
      ./configuration.nix
      ./hardware-configuration.nix
    ];
  };
}
