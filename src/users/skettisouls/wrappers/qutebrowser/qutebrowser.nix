{ wlib, pkgs, ... }:

{
  imports = [ wlib.modules.default ];

  config = {
    package = pkgs.unstable.qutebrowser;
    extraPackages = [ pkgs.rofi pkgs.gnupg ];

    flags."--config-py" = ./config.py;
  };
}
