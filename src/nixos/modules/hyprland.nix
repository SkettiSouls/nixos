{ inputs, ... }:
{ pkgs, config, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (inputs.hyprland.packages.${system}) hyprland xdg-desktop-portal-hyprland;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.regolith.hyprland;
  hypr-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
in
{
  options.regolith.hyprland = {
    enable = mkEnableOption "Hyprland requirements";
    matchMesaVersion = mkEnableOption "Use mesa from hyprland flake's nixpkgs";
    withUWSM = mkEnableOption "Universal wayland session manager";

    cachix.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable building from the Hyprland Cachix";
    };
  };

  config = mkIf cfg.enable {
    services.seatd.enable = true;

    nix.settings = mkIf cfg.cachix.enable {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    hardware.graphics = mkIf cfg.matchMesaVersion {
      package = hypr-pkgs.mesa;
      package32 = hypr-pkgs.pkgsi686Linux.mesa;
    };

    programs = {
      dconf.enable = true;
      xwayland.enable = true;

      hyprland = {
        enable = true;
        package = hyprland;
        portalPackage = xdg-desktop-portal-hyprland;
        xwayland.enable = true;
        withUWSM = cfg.withUWSM;
      };
    };
  };
}
