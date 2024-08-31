{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (config) roles;

  isWorkstation = roles.workstation.enable;
in
{
  config = mkIf isWorkstation {
    # Unneeded atm lol
  };
}
