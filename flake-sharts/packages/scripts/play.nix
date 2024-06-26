{ mpv, fzf, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "play";
  version = "1.0";
  nobuild = true;
  src = ./bash;
  nativeBuildInputs = [ mpv fzf ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/play.sh $out/bin/play
  '';
}
