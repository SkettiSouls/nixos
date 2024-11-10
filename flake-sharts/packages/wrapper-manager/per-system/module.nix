{ lib, flake-parts-lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  inherit (flake-parts-lib)
    mkTransposedPerSystemModule
    ;
in
mkTransposedPerSystemModule {
  name = "wrappedPackages";
  option = mkOption {
    type = types.lazyAttrsOf (types.lazyAttrsOf types.package);
    default = {};
    description = ''
      An attribute set of user packages wrapped by [wrapper-manager](https://github.com/viperML/wrapper-manager).

      `nix build .#<user>.<name>` will build `wrappedPackages.<user>.<package-name>`.
    '';
  };
  file = ./wrapped.nix;
}
