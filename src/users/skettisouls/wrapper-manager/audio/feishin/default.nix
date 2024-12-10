{ pkgs, pkgs', ... }:

{
  wrappers.feishin = {
    basePackage = pkgs'.unstable.feishin;
    pathAdd = [ pkgs.mpv ];
  };
}
