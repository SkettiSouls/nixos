{
  imports = [ ./wrapper-manager/per-system ];

  perSystem = { inputs', pkgs, ... }: let
    callPackageUnstable = inputs'.nixpkgs-unstable.legacyPackages.callPackage;
  in
  {
    packages = {
      creek = callPackageUnstable ./creek {};
      feishin = callPackageUnstable ./bleeding/feishin.nix {};
      rebuild = pkgs.callPackage ./aliaspp/rebuild.nix {};
      xdg-desktop-portal-luminous = pkgs.callPackage ./luminous.nix {};
    };
  };
}
