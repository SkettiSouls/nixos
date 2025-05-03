{ withArgs, ... }:
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
  home = config.home.homeDirectory;
in
{
  imports = [ (withArgs ./modules {}) ];

  # Options for passing around headphones mac address, mostly used for `chp`
  options.basalt.headphones = mkOption {
    type = types.attrs;
    default = {};
  };

  config = {
    home = {
      packages = [ pkgs.neovim ];
      sessionVariables = {
        EDITOR = "nvim";
      };
    };

    programs.git = {
      userName = "SkettiSouls";
      userEmail = "skettisouls@gmail.com";

      signing.key = home + "/.keys/ssh/git.key";
    };

    basalt = {
      bash.enable = true;

      headphones = rec {
        default = momentum4;
        momentum4 = "80:C3:BA:3F:EB:B9";
        spaceQ45 = "E8:EE:CC:4B:FA:2A";
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
          XDG_SCREENSHOTS_DIR = "${pictures}/screenshots";
        };
      };
    };
  };
}
