{
  programs.bash.profileExtra = ''
    if uwsm check may-start && uwsm select; then
      exec uwsm start default
    fi
  '';

  basalt = {
    audio.bluetooth.enable = true;
    mpv.enable = true;
  };
}
