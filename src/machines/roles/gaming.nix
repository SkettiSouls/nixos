{ pkgs, ... }:

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
        steamtinkerlaunch
        unstable.proton-ge-bin
      ];
    };
  };
}
