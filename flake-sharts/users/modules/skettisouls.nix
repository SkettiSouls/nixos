{ config, lib, pkgs, ... }:
let
  cfg = config.shit.users.skettisouls;
  home = config.home.homeDirectory;

  # Headphones
  soundcoreSpaceQ45 = "E8:EE:CC:4B:FA:2A";
  sennheiserMomentum4 = "80:C3:BA:3F:EB:B9";
in
{
  config = {
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
      git.enable = true;
      gpg.enable = true;

      bash = {
        enable = true;
        aliaspp.enable = true;
      };
    };
  };
}
