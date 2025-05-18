{ inputs, ... }:
{ lib, pkgs, ... }:

{
  regolith.boot.systemd.enable = lib.mkDefault true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    package = pkgs.nix;
    registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
    settings = {
      download-buffer-size = 524288000;
      experimental-features = [ "nix-command" "flakes" ];
    };

    extraOptions = ''
      trusted-users = root skettisouls
    '';
  };

  i18n = rec {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };
}
