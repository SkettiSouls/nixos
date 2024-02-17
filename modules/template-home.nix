{ config, lib, pkgs, ... }:

# Replace CAPS accordingly (i.e. for Vim: config.base.NAME -> config.base.vim)

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

# "base" can be changed to whatever EXCEPT for ones already present (i.e. programs, services, etc)

  cfg = config.base.NAME;
in
{
  options.base.NAME = {
    enable = mkEnableOption "DESCRIPTION";
  };

  config = mkIf cfg.enable { 
    # List of packages to included in the module. See https://search.nixos.org/packages.
    home.packages = with pkgs; [ ];

    # Modules and their configurations. See https://mipmip.github.io/home-manager-option-search/.
    # Alternatively, see https://nix-community.github.io/home-manager/options.xhtml for a list instead.
    PREFIX.NAME = {
      enable = true;
    };
  };
}
