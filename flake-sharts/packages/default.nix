{
  perSystem = { pkgs, ... }: {
    packages = {
      # TODO: Make an alias++ meta package somehow
      rebuild = pkgs.callPackage ./aliaspp/rebuild.nix {};
      xdg-desktop-portal-luminous = pkgs.callPackage ./luminous.nix {};
    };
  };
}
