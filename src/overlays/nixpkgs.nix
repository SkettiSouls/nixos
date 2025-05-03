{ inputs, config, ... }:
{ pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  overlay-soft = final: prev: {
    self = config.flake.packages.${system};
  };

  overlay-hard = final: prev: with inputs; {
    bin = bin.packages.${system};
    neovim = neovim.packages.${system}.default;
    boris = boris.packages.${system}.default;
    polyphasia = polyphasia.packages.${system}.default;

    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  nixpkgs.overlays = [
    overlay-soft
    overlay-hard
  ];
}
