_: { ... }:

{
  perSystem = { pkgs, ... }: {
    packages = {
      ### BUNDLES ###
      aliaspp = pkgs.callPackage ./aliaspp/default.nix {};
      scripts = pkgs.callPackage ./scripts/default.nix {};

      ### ALIAS++ ###
      rebuild = pkgs.callPackage ./aliaspp/rebuild.nix {};

      ### SCRIPTS ###
      # TODO: Make backup script
      connect-headphones = pkgs.callPackage ./scripts/connect-headphones.nix {};
      eat = pkgs.callPackage ./scripts/eat.nix {};
      m3u = pkgs.callPackage ./scripts/m3u.nix {};
      mfs = pkgs.callPackage ./scripts/mfs.nix {};
      play = pkgs.callPackage ./scripts/play.nix {};
    };
  };
}
