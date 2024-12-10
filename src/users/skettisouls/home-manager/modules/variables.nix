{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options.basalt.wallpapers = mkOption {
    type = with types; attrsOf (either str path);
    default = {};
  };
}
