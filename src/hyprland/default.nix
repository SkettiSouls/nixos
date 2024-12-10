{
  config.flake.homeModules = {
    hyprland = import ./hyprland.nix;
    hyprpaper = import ./hyprpaper.nix;
  };
}
