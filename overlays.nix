{ inputs, pkgs, self, ... }:
with inputs;
let
  system = pkgs.stdenv.hostPlatform.system;


  overlay-unstable = final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

in
{
  nixpkgs.overlays = [
    overlay-unstable
  ];
}
