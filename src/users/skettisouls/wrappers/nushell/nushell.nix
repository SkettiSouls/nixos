{ wlib, pkgs, ... }:

{
  imports = [ wlib.wrapperModules.nushell ];
  config = {
    package = pkgs.unstable.nushell;

    "config.nu".path = ./config.nu;
    "env.nu".path = ./env.nu;
  };
}
