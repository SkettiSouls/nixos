{ config, withSystem, ... }:
let
  inherit (config.flake.machines.argon) system users;
in {
  flake.machines.argon.users.skettisouls.wrappers.fuzzel = withSystem system
    ({ wlib, pkgs, ... }:
    wlib.wrapPackage {
      imports = [ wlib.wrapperModules.fuzzel ];
      config = {
        inherit pkgs;
        settings.main = {
          terminal = "${users.skettisouls.wrappers.kitty}/bin/kitty";
          layer = "overlay";
          show-actions = true;
          fields = "filename,name,generic,categories";
          lines = 20;
          width = 40;
          vertical-pad = 10;
          horizontal-pad = 20;
        };
      };
    });
}
