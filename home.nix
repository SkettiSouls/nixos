{ ... }:

/* Eldritch Horror
let
  shitConfig = builtins.mapAttrs (_: v: { enable = true; } // v);
in
*/

{
  imports = [
    ./modules/home
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "skettisouls";
  home.homeDirectory = "/home/skettisouls";

  # Packages that should be installed to the user profile.
  home.packages = [];

  # Funny Hyprland brrrr
  home.file = {
    ".config/hypr/hyprpaper.conf".source = ./shit/hypr/hyprpaper.conf;
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
    bluetooth.enable = true;
    brave.enable = true;
    discord.enable = true;
    easyeffects.enable = true;
    git.enable = true;
    hyprland.enable = true;
    kitty.enable = true;
    mpv.enable = true;
    qutebrowser.enable = true;
    udiskie.enable = true;
    xdg.portal.enable = true;
  };
}
