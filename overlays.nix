{ inputs, pkgs, self, ... }:
with inputs;
let
  system = pkgs.stdenv.hostPlatform.system;

  overlay-unstable = final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    vesktop-unstable = inputs.vesktop.legacyPackages.${system}.vesktop;
  };


  overlay-sketti = final: prev: {
    sketti = self.packages.${system};
  };

  overlay-hyprland = final: prev: {
    hyprland-git = inputs.hyprland.packages.${system}.hyprland;
    hyprpicker-git = inputs.hyprpicker.packages.${system}.default;
  };

in
{
  nixpkgs.overlays = [
    overlay-unstable
    overlay-sketti
    overlay-hyprland
  ];
}
