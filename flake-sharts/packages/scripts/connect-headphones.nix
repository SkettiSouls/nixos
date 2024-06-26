{ bluez, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "connect-headphones";
  version = "1.0";
  nobuild = true;
  src = ./bash;
  nativeBuildInputs = [ bluez ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/connect-headphones.sh $out/bin/connect-headphones
  '';
}
