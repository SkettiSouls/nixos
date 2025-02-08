{ getSystem, config, ... }:
let
  system = "x86_64-linux";
  flake' = getSystem system;
  wrappers = flake'.wrappedPackages.skettisouls;
in
{
  flake.users.skettisouls = {
    home-manager = {
      enable = true;
      modules = import ./home-manager;
    };

    wrapper-manager = {
      enable = true;
      modules = ./wrapper-manager;
    };

    packages = with wrappers; [
      eza
      feishin
      nushell
    ];
  };
}
