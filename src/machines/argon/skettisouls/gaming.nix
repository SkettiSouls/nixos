{ inputs, ... }:
{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      bolt-launcher
      inputs.nixpkgs-openmw.legacyPackages.${pkgs.system}.openmw
    ];
  };
}
