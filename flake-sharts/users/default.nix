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
    skettisouls = ./modules/skettisouls;
    wrapper_temp = ./modules/wrapper_temp; # Avoid nuking my entire home config (git, terminal, etc)

    default = { host, ... }: {
      users.users = mapAttrs (user: hostList:
        # Check if the host is present in the user's host list
        if elem host hostList then {
          # TODO: Add more defaults
          isNormalUser = true;
          extraGroups = mkDefault [ "networkmanager" "wheel" ];
        } else {}
      ) config.homes;
    };
  };
}
