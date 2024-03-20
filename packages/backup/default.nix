{ rsync, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "backup";
  version = "1.0";
  nobuild = true;
  src = ./.;
  nativeBuildInputs = [ rsync ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/backup.sh $out/bin/backup
  '';
};
