{ pkgs, ... }:

{
  wrappers.qutebrowser = {
    basePackage = pkgs.unstable.qutebrowser;
    pathAdd = with pkgs; [ rofi gnupg ];

    programs.qutebrowser.prependFlags = [ "--config-py" ./config.py ];
  };
}
