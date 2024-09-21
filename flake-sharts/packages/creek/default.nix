{ stdenv
, fetchFromGitHub
, callPackage
, wayland
, pixman
, zig
, fcft
, pkg-config
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "creek";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "nmeum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3Q690DEMgPqURTHKzJwH5iVyTLvgYqNpxuwAEV+/Lyw=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland
    zig.hook
  ];

  buildInputs = [
    pixman
    wayland-protocols
    fcft
  ];

  postPatch = ''
    ln -s ${callPackage ./zig-deps.nix {}} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  dontConfigure = true;
}
