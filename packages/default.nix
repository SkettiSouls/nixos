{ nixpkgs, ... }:

{

  packages.x86_64-linux = {
    play = nixpkgs.callPackage ./play {};
  };
}
