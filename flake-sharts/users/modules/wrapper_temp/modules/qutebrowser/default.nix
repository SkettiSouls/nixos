{ pkgs, ... }:

{
  wrappers.qutebrowser = {
    basePackage = pkgs.qutebrowser;
    pathAdd = with pkgs; [ gobble rofi gpg ];

    flags = [ "--config-py" ./config.py ];
  };
}
