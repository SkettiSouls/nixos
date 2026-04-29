{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  config = {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
      };
    };

    xdg = {
      enable = true;

      cacheHome = "${home}/.cache";
      configHome = "${home}/.config";
      dataHome = "${home}/.local/share";
      stateHome = "${home}/.local/state";

      userDirs = rec {
        enable = true;
        createDirectories = true;

        download = "${home}/Downloads";
        desktop = "${home}/Desktop";
        documents = "${home}/Documents";
        music = "${home}/Music";
        pictures = "${home}/Pictures";
        videos = "${home}/Videos";

        templates = null;
        publicShare = null;

        extraConfig = {
          SCREENSHOTS = "${pictures}/screenshots";
        };
      };
    };
  };
}
