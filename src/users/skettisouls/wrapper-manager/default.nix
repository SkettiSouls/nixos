{ lib, withArgs, ... }:

{
  imports =
    (lib.getModulesExcept [ "polyphasia" ] ./.)
    ++ [(withArgs ./tools/polyphasia/default.nix {})];
}
