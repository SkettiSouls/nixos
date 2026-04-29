{ config, inputs, ... }:
{
  flake.modules.services.discord-bots =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in {
      imports = [ config.flake.modules.nixos.discord-bots ];

      services.discord.bots = {
        boris = {
          enable = true;
          package = inputs.boris.packages.${system}.default;
        };
      };
    };
}
