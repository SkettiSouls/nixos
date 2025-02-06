{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.basalt.browsers.brave;
in
{
  options.basalt.browsers.brave = {
    enable = mkEnableOption "brave";
  };

  config = mkIf cfg.enable {
    # TODO: Make this module programs.chromium with brave as the package.
    home.packages = with pkgs; [
      brave
    ];

    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "hfjbmagddngcpeloejdejnfgbamkjaeg"; } # Vimium C
        { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC-Browser
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
        { id = "gebbhagfogifgggkldgodflihgfeippi"; } # Return Youtube Dislike
      ];
    };
  };
}
