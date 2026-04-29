{ config, ... }:
let
  inherit (config.flake.machines.argon) users;
  inherit (users.skettisouls) wrappers pkgs;
in
{
  flake.machines.argon.users.skettisouls = {
    packages = with pkgs; [
      wrappers.feishin
    ];
  };
}
