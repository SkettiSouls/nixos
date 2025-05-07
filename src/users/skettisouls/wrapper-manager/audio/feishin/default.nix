{ pkgs, ... }:

{
  wrappers.feishin = {
    # Currently depends on electron 33, which is EOL, so we can't use unstable.
    basePackage = pkgs.feishin;
    pathAdd = [ pkgs.mpv ];
  };
}
