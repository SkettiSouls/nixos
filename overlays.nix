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

  overlay-sketti = final: prev: {
    sketti = self.packages.${system};
  };

  overlay-hyprland = final: prev: {
    hyprland-src = inputs.hyprland.packages.${system}.hyprland;
  };

in
{
  nixpkgs.overlays = [
    overlay-unstable
    overlay-sketti
    overlay-hyprland
  ];
}
