{ wlib, pkgs, ... }:

{
  imports = [ wlib.modules.default ];

  config = {
    package = pkgs.eza;
    flags = {
      "--icons" = "always";
      "--group-directories-first" = true;
    };
  };
}
