{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options.shit.wallpapers = mkOption {
    type = with types; attrsOf (either str path);
    default = {};
  };
}
