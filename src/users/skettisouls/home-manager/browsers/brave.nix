{ ... }:
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
