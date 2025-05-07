{ lib, inputs, ... }:
{ config, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types;
  inherit (config.basalt) defaultApps;
  inherit (inputs.neovim.packages.${pkgs.system}) neovim;
  home = config.home.homeDirectory;

  mkVar = mkOption {
    type = types.str;
    default = "";
  };
in
{
  imports = lib.applyModules ./.;

  # Options for passing around headphones mac address, mostly used for `chp`
  options.basalt = {
    headphones = mkOption {
      type = types.attrs;
      default = {};
    };

    defaultApps = {
      launcher = mkVar;
      browser = mkVar;
    };
  };

  config = {
    home = {
      packages = [ neovim ];
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
      browser.default = mkIf (defaultApps.browser != "") defaultApps.browser;

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
