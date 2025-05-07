{ ... }:
{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.basalt.browsers.brave;
in
{
  options.basalt.browsers.brave = {
    enable = mkEnableOption "brave";
    package = mkOption {
      type = types.package;
      default = pkgs.brave;
    };
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = lib.mkDefault cfg.package;
      extensions = [
        { id = "hfjbmagddngcpeloejdejnfgbamkjaeg"; } # Vimium C
        { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC-Browser
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
        { id = "gebbhagfogifgggkldgodflihgfeippi"; } # Return Youtube Dislike
      ];
    };
  };
}
