{ config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
    ({ wlib, pkgs, ... }:
    {
      wrappers.qutebrowser = wlib.wrapPackage {
        inherit pkgs;
        # TODO: Figure out how to include greasemonkey scripts
        package = pkgs.unstable.qutebrowser;
        extraPackages = [ pkgs.rofi pkgs.gnupg ];

        flags."--config-py" = ./config.py;
      };
    });
}
