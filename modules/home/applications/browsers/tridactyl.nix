{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkIf
    ;

  schizofox = config.shit.browsers.schizofox;
in
{
  config = mkIf schizofox.enable {
    home.packages = with pkgs; [
      tridactyl-native
    ];

    # Install tridactyl beta
    programs.schizofox = {
      # FIXME: Doesn't find the native messenger.
      extensions.extraExtensions = {
       "tridactyl.vim.betas@cmcaine.co.uk".install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi";
      };
    };
  };
}

