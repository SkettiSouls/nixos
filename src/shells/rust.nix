{ inputs, ... }:

{
  perSystem = { pkgs, system, ... }: let
    rpkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ inputs.rust-overlay.overlays.default ];
    };
  in {
    devShells.rust = pkgs.mkShell {
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

      packages = [
        inputs.neovim.packages.${system}.neovim
        (rpkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" ];
        })
      ];
    };
  };
}
