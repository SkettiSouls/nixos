{ config, lib, pkgs, flakeRoot, ... }:

{
  home.packages = with pkgs; [
    rofi
  ];

  basalt = {
    audio = {
      bluetooth.enable = true;
    };

    neofetch = {
      trollOS.enable = true;
    };

    browsers = {
      brave.enable = true;
      qutebrowser.enable = true;
    };
  };

  xdg.browser.default = "qutebrowser";
}
