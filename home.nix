{ inputs, pkgs, ... }:

{
  imports = [
    ./modules/home
    ./overlays.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "skettisouls";
    homeDirectory = "/home/skettisouls";
    pointerCursor = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
    };
    packages = with pkgs; [
      scarab
      heroic
      minetest
      element-desktop
    ];
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  shit = {
    bash.enable = true;
    discord.enable = true;
    git.enable = true;
    hyprland.enable = true;
    kitty.enable = true;
    mangohud.enable = true;
    mpv.enable = true;
    udiskie.enable = true;
    vesktop.enable = true;
    xdg.portal.enable = true;

    audio = {
      bluetooth.enable = true;
      carla.enable = true;
    };

    browsers = {
      default = "qutebrowser";
      brave.enable = true;
      qutebrowser.enable = true;
      /*firefox = {
        enable = true;
        tridactyl = true;
      };*/
    };

    fetch = {
      active = with pkgs; [
        neofetch
        fastfetch
      ];
    };
  };
}
