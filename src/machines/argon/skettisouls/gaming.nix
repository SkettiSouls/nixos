{ inputs, ... }:
{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      bolt-launcher
      # Fails to build
      # inputs.nixpkgs-openmw.legacyPackages.${pkgs.system}.openmw
    ];
  };
}
