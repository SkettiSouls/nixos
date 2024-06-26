{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "eat";
  version = "1.0";
  nobuild = true;
  src = ./bash;
  installPhase = ''
    mkdir -p $out/bin
    cp $src/eat.sh $out/bin/eat
  '';
}