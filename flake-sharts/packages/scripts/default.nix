{ bluez
, fzf
, mpv
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "scripts";
  version = "1.0";
  nobuild = true;
  src = ./bash;

  nativeBuildInputs = [
    bluez
    fzf
    mpv
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/play.sh $out/bin/play
    cp $src/eat.sh $out/bin/eat
    cp $src/connect-headphones.sh $out/bin/connect-headphones
    cp $src/music-formatter.sh $out/bin/mfs
    cp $src/playlist-tool.sh $out/bin/m3u
  '';
}
