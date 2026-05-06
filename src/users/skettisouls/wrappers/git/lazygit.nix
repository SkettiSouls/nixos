{ config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
  ({ system, wlib, pkgs, ... }:
  {
    wrappers.lazygit = wlib.wrapPackage {
      inherit pkgs;

      package = pkgs.lazygit;
      extraPackages = [
        config.flake.users.skettisouls."${system}".wrappers.git
      ];

      flags = {
        "--use-config-file" = ./lazygit.yml;
      };
    };
  });
}
