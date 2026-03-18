{ inputs, ... }:
{ pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  config.services.discord.bots = {
    boris = {
      enable = true;
      package = inputs.boris.packages.${system}.default;
    };
  };
}
