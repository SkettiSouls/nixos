{ inputs, pkgs, self, ... }: with inputs;
let
  inherit (pkgs.stdenv.hostPlatform) system;

  overlay-unstable = final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    vesktop-unstable = vesktop.legacyPackages.${system}.vesktop;
  };

  overlay-sketti = final: prev: {
    sketti = self.packages.${system};
    neovim = neovim.packages.${system}.default;
  };

  overlay-hyprland = final: prev: {
    hyprland-git = hyprland.packages.${system}.default;
    hyprpicker-git = hyprpicker.packages.${system}.default;
    xdph-git = hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };
in
{
  nixpkgs.overlays = [
    overlay-unstable
    overlay-sketti
    overlay-hyprland
  ];
}
