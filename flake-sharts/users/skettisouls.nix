{ config, pkgs, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg.enable = config.shit.users.skettisouls;
  home = config.home-manager.users.skettisouls.home.homeDirectory;

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

    home-manager.users.skettisouls = {
      home.sessionVariables = {
        EDITOR = "nvim";
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
        browsers.default = lib.mkDefault "qutebrowser";

        bash = {
          enable = true;
          aliaspp.enable = true;
        };
      };
    };
  };
}
