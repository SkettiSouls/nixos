{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.audio.patchbay;
in
{
  options.shit.audio.patchbay = {
    enable = mkEnableOption "desc";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      carla
      qpwgraph
      rnnoise-plugin
    ];
    
    home.file.".config/rncbc.org/qpwgraph.conf".source = ../../../shit/qpwgraph/qpwgraph.conf;
  };
}
