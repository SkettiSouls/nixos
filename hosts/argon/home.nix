{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkIf
    ;

  kitty = config.shit.kitty;
in
{
  imports = [
    ../../modules/home
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  home = {
    username = "skettisouls";
    homeDirectory = "/home/skettisouls";
    packages = with pkgs; [
      rofi
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
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  shit = {
    audio = {
      bluetooth.enable = true;
    };

    hyprland = {
      monitors = {
        "HDMI-A-1" = {};
      };
    };

    browsers = {
      default = "brave";
      brave.enable = true;
      qutebrowser.enable = true;
      schizofox.enable = true;
    };

    fetch = {
      neofetch = {
        enable = true;
        distroName = "TrollOS ${config.home.version.release}";
        image = {
          source = "${config.home.homeDirectory}/Pictures/meme/troll/troll3D.png";
          renderer = mkIf kitty.enable "kitty";
          size = "320px";
        };
      };
    };
  };
}
