{ ... }:
{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.basalt.desktops.niri;
in
{
  # TODO: Make a full module for niri, waiting on https://github.com/NixOS/nixpkgs/pull/412029
  options.basalt.desktops.niri = {
    enable = mkEnableOption "Niri config";

    package = mkOption {
      type = with types; nullOr package;
      default = pkgs.niri;
      description = "The niri package to use. Set this to null if you wish to use the NixOS module to install Niri.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkIf (cfg.package != null) [ cfg.package ];
    xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;
  };
}
