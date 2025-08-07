{ pkgs, ... }:
let
  proton-ge-base = pkgs.unstable.proton-ge-bin;
  proton-ge = proton-ge-base.override { steamDisplayName = proton-ge-base.version; };
in
{
  # TODO: More gaming changes
  config = {
    environment.systemPackages = with pkgs; [
      heroic
      prismlauncher
      unstable.wineWowPackages.staging
      winetricks
    ];

    regolith.steam = {
      enable = true;
      protontricks.enable = true;
      protonPackages = with pkgs; [
        proton-ge
        steamtinkerlaunch
      ];
    };
  };
}
