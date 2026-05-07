{ flakeRoot }: _:
{
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
