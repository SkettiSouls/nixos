{ config, pkgs, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg.enable = config.shit.users.skettisouls;
  homeManager = config.home-manager.users.skettisouls;
  home = homeManager.home.homeDirectory;

  notServer = config.roles.server.enable != true;

  # Headphones
  soundcoreSpaceQ45 = "E8:EE:CC:4B:FA:2A";
  sennheiserMomentum4 = "80:C3:BA:3F:EB:B9";
in
{
  options.shit.users.skettisouls = mkEnableOption "SkettiSouls user module";

  config = mkIf cfg.enable {
    users.users.skettisouls = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        neovim
      ];
    };

    shit.home-manager = {
      enable = true;
      users.skettisouls = import ../../hosts/${config.networking.hostName}/home.nix;
    };

    home-manager.users.skettisouls = {
      home = {
        username = "skettisouls";
        homeDirectory = "/home/skettisouls";
        sessionVariables = {
          EDITOR = "nvim";
        };
      };

      peripherals.bluetooth = {
        headphones = sennheiserMomentum4;
      };

      programs.git = {
        userName = "SkettiSouls";
        userEmail = "skettisouls@gmail.com";

        signing.key = home + "/.keys/ssh/git.key";
      };

      shit = {
        fetch.trollOS.enable = mkIf notServer true;
        git.enable = true;
        gpg.enable = true;

        bash = {
          enable = true;
          aliaspp.enable = true;
        };

        browsers = mkIf notServer {
          default = lib.mkDefault "qutebrowser";
          qutebrowser.enable = true;
        };
      };
    };
  };
}
