{ config, ... }:
let
  inherit (config.flake) hardwareModules networks roles;
in
{
  flake.machines.argon = {
    system = "x86_64-linux";
    users = [ "skettisouls" ];
    hardware = with hardwareModules; [ gpu.amd bluetooth ];
    roles = with roles; [ desktop gaming workstation ];
    networks = with networks; [ peridot ];
    modules = [
      ./configuration.nix
      ./hardware-configuration.nix
    ];
  };
}
