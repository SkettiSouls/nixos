{ pkgs, ... }:

{
  wrappers.eza = {
    basePackage = pkgs.eza;

    prependFlags = [ "--icons=always" "--group-directories-first" ];
  };
}
