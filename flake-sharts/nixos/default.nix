_: {config, inputs, ...}:

let
  inherit (config.flake.lib)
    combineModules
    ;

in
{
  flake.nixosModules = {
    home-manager = import ./modules/home-manager.nix;
    pipewire = import ./modules/pipewire.nix;
    steam = import ./modules/steam.nix;

    roles = config.flake.roles.default;
    default.imports = combineModules config.flake.nixosModules;
  };
}
