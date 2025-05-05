{ ... }:
{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      heroic
      lutris
      minetest
      prismlauncher
      unstable.wineWowPackages.staging
      winetricks
    ];

    # TODO: Figure out how to set the order options are generated in
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };

    # Workaround, see todo above
    xdg.configFile."MangoHud/MangoHud.conf".source = ./MangoHud.conf;
  };
}
