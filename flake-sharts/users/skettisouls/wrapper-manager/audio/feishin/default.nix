{ pkgs, pkgs', ... }:

{
  wrappers.feishin = {
    basePackage = pkgs'.self.feishin;
    pathAdd = [ pkgs.mpv ];
  };
}
