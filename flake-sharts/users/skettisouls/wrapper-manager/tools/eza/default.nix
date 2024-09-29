{ pkgs, ... }:

{
  wrappers.eza = {
    basePackage = pkgs.eza;

    flags = [ "--icons=always" "--group-directories-first" ];
  };
}
