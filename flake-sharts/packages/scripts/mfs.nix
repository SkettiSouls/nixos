{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "music-formatter";
  version = "1.0";
  nobuild = true;
  src = ./bash;
  installPhase = ''
    mkdir -p $out/bin
    cp $src/music-formatter.sh $out/bin/mfs
  '';
}
