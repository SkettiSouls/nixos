{ flakeRoot, lib, ... }:
{ pkgs, ... }:

{
  imports = lib.applyModules ./.;

  home = {
    pointerCursor = {
      name = "phinger-cursor-dark";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
    };

    packages = with pkgs; [
      easyeffects
      pulsemixer
      unstable.discord
    ];
  };

  programs.bash.profileExtra = ''
    if uwsm check may-start && uwsm select; then
      exec uwsm start default
    fi
  '';

  services.wpaperd = {
    enable = true;
    settings = {
      any.path = "${flakeRoot}/etc/images/wallpapers/urple.jpg";
    };
  };

  basalt = {
    audio.bluetooth.enable = true;
    mpv.enable = true;
  };
}
