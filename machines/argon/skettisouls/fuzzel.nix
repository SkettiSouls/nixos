{ inputs, config, withSystem, ... }:
let
  inherit (inputs.wrapper-modules.lib) evalModule;
  inherit (config.flake.machines.argon) system users;

  wrapper = evalModule (
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.fuzzel ];
      config.settings = {
        main = {
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

  fuzzel = withSystem system ({ pkgs, ... }: wrapper.config.wrap { inherit pkgs; });
in {
  flake.machines.argon.users.skettisouls.wrappers = { inherit fuzzel; };
}
