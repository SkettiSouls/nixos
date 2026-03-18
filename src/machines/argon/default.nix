{ inputs, withArgs, ... }:
{ config, ... }:
let
  system = "x86_64-linux";
  inherit (config.flake)
    hardwareModules
    networks
    roles
    wrappers
    ;

  wpkgs = wrappers.${system};
  npkgs = inputs.neovim.packages.${system};
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
          npkgs.neovim
        ];
      };
    };

    modules = [
      ./configuration.nix
      ./hardware-configuration.nix
    ];
  };
}
