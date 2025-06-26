{ lib, withArgs, ... }:

{
  imports =
    (lib.getModulesExcept [ "polyphasia" ] ./.)
    ++ [(withArgs ./misc/polyphasia/default.nix {})];
}
