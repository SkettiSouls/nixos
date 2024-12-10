# FIXME?: Screensharing crashes vesktop
{ lib
, bash
, fetchFromGitHub
, libxkbcommon
, llvmPackages
, makeWrapper
, meson
, ninja
, pipewire
, pkg-config
, rustPlatform
, slurp
, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-luminous";
  version = "0.1.4";

  cargoHash = "sha256-hcOO5m3JbqSyK7Did+VPSGeZHhj41Ldw1KzwBHPHw+E=";
  src = fetchFromGitHub {
    owner = "waycrate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mt+ZJ87Z8xluNaf4d2cvF2toPhUC4Qe6OsqDeamHsU4=";
  };

  nativeBuildInputs = [ llvmPackages.clang meson ninja pkg-config makeWrapper ];
  buildInputs = [ pipewire wayland-protocols libxkbcommon slurp ];

  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  mesonBuildType = "release";

  # Required to let meson run, else `rustPackage` will overwrite it.
  configurePhase = "";

  postInstall = ''
    wrapProgram $out/libexec/xdg-desktop-portal-luminous --prefix PATH ":" ${lib.makeBinPath [ bash slurp ]}
  '';
}
