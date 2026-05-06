{ config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
  ({ wlib, pkgs, ... }:
  {
    wrappers.eza = wlib.wrapPackage {
      inherit pkgs;
      package = pkgs.eza;
      flags = {
        "--icons" = "always";
        "--group-directories-first" = true;
      };
    };
  });
}
