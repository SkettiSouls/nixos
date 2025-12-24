{ ... }:
{ pkgs, config, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.regolith.hyprland;
in
{
  options.regolith.hyprland = {
    enable = mkEnableOption "Hyprland requirements";
    withUWSM = mkEnableOption "Universal wayland session manager";

    cachix.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable building from the Hyprland Cachix";
    };


    externalFlake = {
      enable = mkEnableOption "Use an external flake for hyprland packages";
      matchMesaVersion = mkEnableOption "Use mesa from hyprland flake's nixpkgs";

      input = mkOption {
        type = types.attrs;
        description = "Flake input containing hyprland packages";
      };
    };
  };

  config = mkIf cfg.enable (let 
    hypr-pkgs =
      if cfg.externalFlake.enable
      then cfg.externalFlake.input.inputs.nixpkgs.legacyPackages.${system}
      else pkgs;

    inherit (hypr-pkgs) hyprland xdg-desktop-portal-hyprland;
  in {
    services.seatd.enable = true;

    nix.settings = mkIf cfg.cachix.enable {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    hardware.graphics = mkIf cfg.externalFlake.matchMesaVersion (lib.mkForce {
      package = hypr-pkgs.mesa;
      package32 = hypr-pkgs.pkgsi686Linux.mesa;
    });

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
  });
}
