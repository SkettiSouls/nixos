{ withArgs, ... }:
{ getSystem, inputs, ... }:
let
  # pkgs = {
  #   x86 = inputs.nixpkgs.legacyPackages.x86_64-linux;
  #   arm = inputs.nixpkgs.legacyPackages.aarch64-linux;
  # };

  wrappers = {
    x86 = (getSystem "x86_64-linux").wrappers.skettisouls;
    # arm = (getSystem "aarch64-linux").wrappers.skettisouls;
  };
in
{
  config.flake.users = {
    skettisouls = {
      homes.argon = withArgs ./home-manager/argon.nix {};
      wrapperModules = import ./wrapper-manager;

      packages."x86_64-linux" = with wrappers.x86; [
        eza
        feishin
        nushell
      ];
    };
  };
}
