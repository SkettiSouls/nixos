{ config, lib, ... }:
let
  inherit (lib)
    elem
    mapAttrs
    mkDefault
    ;
in
{
  config.flake.userModules = {
    skettisouls = ./modules/skettisouls.nix;

    default = { machine, ... }: {
      users.users = mapAttrs (user: hostList:
        # Check if the host is present in the user's host list
        if elem machine hostList then {
          # TODO: Add more defaults
          isNormalUser = true;
          extraGroups = mkDefault [ "networkmanager" "wheel" ];
        } else {}
      ) config.homes;
    };
  };
}
