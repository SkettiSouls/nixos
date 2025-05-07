{ inputs, ... }:
{ pkgs, ... }:

{
  config.services.discord.bots = {
    boris = {
      enable = true;
      package = inputs.boris.packages.${pkgs.system}.default;
    };
  };
}
