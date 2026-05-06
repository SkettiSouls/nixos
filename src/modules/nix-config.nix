{ inputs, ... }:
{
  flake.modules.nixos.nix-config = { lib, pkgs, ... }:

  {
    nixpkgs.config.allowUnfree = true;

    nix = {
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      package = pkgs.nix;
      registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
      settings = {
        download-buffer-size = 524288000;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };
  };
}
