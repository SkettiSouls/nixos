{ fzf, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "playlist-tool";
  version = "1.0";
  nobuild = true;
  src = ./bash;
  nativeBuildInputs = [ fzf ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/playlist-tool.sh $out/bin/m3u
  '';
}
