{ pkgs, ... }:

{
  wrappers.qutebrowser = {
    basePackage = pkgs.unstable.qutebrowser;
    pathAdd = with pkgs; [ rofi gnupg ];

    flags = [ "--config-py" ./config.py ];
  };
}
