# WIP: Hopefully I can get the wrapper to include portals.
{
  flake.modules.wrappers.niri =
    { config, wlib, pkgs, lib, ... }:
    {
      _file = ./niri.nix;
      imports = [ wlib.wrapperModules.niri ];

      options = {
        xwayland.enable = lib.mkEnableOption "xwayland" // { default = true; };
        useGnomePortal = lib.mkEnableOption "integration with xdp-gnome" // { default = true; };
      };

      # TODO 6: Include xdg-desktop-portal setup in the wrapper
      config = {
        extraPackages =
          lib.optionals config.xwayland.enable [ pkgs.xwayland-satellite ]
          ++ lib.optionals config.useGnomePortal (with pkgs; [ nautilus ]);
      };
    };
}
