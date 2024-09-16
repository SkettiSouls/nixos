{ pkgs, ... }:
{
  config.services.discord.bots = {
    boris = {
      enable = true;
      package = pkgs.boris;
    };
  };
}
