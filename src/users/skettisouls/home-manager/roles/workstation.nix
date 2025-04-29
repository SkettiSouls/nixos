{ config, lib, host, ... }:
let
  inherit (config.flake) roles machines;
  isWorkstation = lib.elem roles.workstation machines.${host}.roles;
in
{
  config = lib.mkIf isWorkstation {
    # Unneeded atm lol
    roles.workstation.enable = true;
  };
}
