{ wlib, pkgs, ... }:

{
  imports = [ wlib.modules.default ];

  # TODO?: Figure out how to include config with electron apps
  config = {
    package = pkgs.feishin;
    extraPackages = [ pkgs.mpv ];
  };
}
