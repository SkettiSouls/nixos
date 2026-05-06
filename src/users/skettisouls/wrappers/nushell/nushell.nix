{ config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
  ({ wlib, pkgs, ... }:
  {
    wrappers.nushell = wlib.wrapPackage {
      imports = [ wlib.wrapperModules.nushell ];

      config = {
        inherit pkgs;
        package = pkgs.unstable.nushell;

        "config.nu".path = ./config.nu;
        "env.nu".path = ./env.nu;
      };
    };
  });
}
