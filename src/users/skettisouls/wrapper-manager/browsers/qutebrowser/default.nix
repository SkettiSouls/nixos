{ pkgs, ... }:

{
  wrappers.qutebrowser = {
    basePackage = pkgs.qutebrowser;
    pathAdd = with pkgs; [ gobble rofi gnupg ];

    flags = [ "--config-py" ./config.py ];
  };
}
