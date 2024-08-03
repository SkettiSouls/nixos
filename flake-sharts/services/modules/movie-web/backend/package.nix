{ stdenv
, nodejs
, pnpm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "backend";
  version = "1.3.1";

  src = fetchGit {
    url = "http://git.fluorine.lan/movie-web/backend";
    rev = "f5cec7ba247bdd6ea19c9e28c4f218d26e29fbb8";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-vUIECPaGXx/TmDAsx7R1ZAP/XjYH3BZrIrhR/G9LdUI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  buildPhase = ''
    pnpm run build
  '';

  installPhase = ''
    mkdir -p $out
    rm Dockerfile dev.Dockerfile LICENSE README.md yarn.lock
    cp -r * $out
  '';

  passthru = {
    inherit (finalAttrs) pnpmDeps;
  };
})
