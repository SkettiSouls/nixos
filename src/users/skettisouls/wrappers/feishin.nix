{ config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
  ({ wlib, pkgs, ... }:
  {
    wrappers.feishin = wlib.wrapPackage {
      inherit pkgs;
      # TODO?: Figure out how to include config with electron apps
      package = pkgs.feishin;
      extraPackages = [ pkgs.mpv ];
    };
  });
}
