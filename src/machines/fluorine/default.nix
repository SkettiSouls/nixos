{ config, ... }:
let
  inherit (config.flake) networks roles;
in
{
  flake.machines.fluorine = {
    system = "x86_64-linux";
    users = [ "skettisouls" ];
    roles = with roles; [ workstation ];
    networks = with networks; [ peridot ];
    modules = [
      ./configuration.nix
      ./hardware-configuration.nix
      ./services.nix
    ];
  };
}
