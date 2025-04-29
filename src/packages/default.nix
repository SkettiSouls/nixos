{
  perSystem = { inputs', pkgs, ... }: let
    callPackageUnstable = inputs'.nixpkgs-unstable.legacyPackages.callPackage;
  in
  {
    packages = {
      creek = callPackageUnstable ./creek {};
      rebuild = pkgs.callPackage ./rebuild {};
      xdg-desktop-portal-luminous = pkgs.callPackage ./luminous.nix {};
    };
  };
}
