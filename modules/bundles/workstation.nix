{ config, ... }:
let
  inherit (config) flake;
in
{
  flake.modules.bundles.workstation =
    { lib, pkgs, ... }:
    {
      imports = with flake.modules.nixos; [
        networking
        nix-index
      ];

      config = {
        environment.systemPackages = with pkgs; [
          comma
          fzf
          git
        ];

        programs.direnv = {
          enable = lib.mkDefault true;
          silent = lib.mkDefault true;
        };

        fonts.packages = [ pkgs.nerd-fonts.dejavu-sans-mono ];
      };
    };
}
